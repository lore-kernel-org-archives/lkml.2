Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1KUV3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:29:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37676 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1KUV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111121210908.GJ25776@google.com>
References: <20111102160208.GA6657@zeus>
	<20111102163109.GA29430@core.coreip.homeip.net>
	<20111103155956.GG4417@google.com>
	<20111103184559.GA3295@zeus>
	<20111103213959.GP4417@google.com>
	<20111104134347.GA2480@zeus>
	<20111104161431.GZ4417@google.com>
	<20111104173441.GA2157@zeus>
	<CAH3drwaXcUy1vz8bvHwE2_iga5WUsWn_Dp0oe_0r3UacV0vT_A@mail.gmail.com>
	<20111104230758.GA7332@zeus>
	<20111121210908.GJ25776@google.com>
Date: Mon, 21 Nov 2011 16:29:23 -0500
Message-ID: <CAH3drwbtWJcPOixW0gze0e0jbTn_uY0x5E=KY8N-WDcb1t8h2w@mail.gmail.com>
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
From: Jerome Glisse <j.glisse@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Watts <akwatts@ymail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 4:09 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Nov 04, 2011 at 06:08:20PM -0500, Andrew Watts wrote:
>> On Fri, Nov 04, 2011 at 01:35:53PM -0400, Jerome Glisse wrote:
>> >
>> > I need full dmesg
>> >
>> > Cheers,
>> > Jerome
>>
>> Hi. Just noticed I attached a gzip of my dmesg last time by mistake.
>>
>> Here goes as text/plain.
>
> Out of curiosity, did it get somewhere?
>
> Thanks.
>
> --
> tejun
>

Yeah i am pretty sure i know what's going wrong but there is no easy
fix, there is a deadlock in the kernel when gem wait ioctl is call on
scanout buffer and that a gpu reset happen

Cheers,
Jerome
