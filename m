Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab1KDRfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:35:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64640 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab1KDRfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <20111104173441.GA2157@zeus>
References: <20111101124759.GA1326@zeus>
	<20111102054658.GA29035@core.coreip.homeip.net>
	<20111102160208.GA6657@zeus>
	<20111102163109.GA29430@core.coreip.homeip.net>
	<20111103155956.GG4417@google.com>
	<20111103184559.GA3295@zeus>
	<20111103213959.GP4417@google.com>
	<20111104134347.GA2480@zeus>
	<20111104161431.GZ4417@google.com>
	<20111104173441.GA2157@zeus>
Date: Fri, 4 Nov 2011 13:35:53 -0400
Message-ID: <CAH3drwaXcUy1vz8bvHwE2_iga5WUsWn_Dp0oe_0r3UacV0vT_A@mail.gmail.com>
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
From: Jerome Glisse <j.glisse@gmail.com>
To: Andrew Watts <akwatts@ymail.com>
Cc: Tejun Heo <tj@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 1:34 PM, Andrew Watts <akwatts@ymail.com> wrote:
> On Fri, Nov 04, 2011 at 09:14:31AM -0700, Tejun Heo wrote:
>> Andrew, can you please kill the X server after the hang and see
>> whether that brings the system back?  I think sshd should still work
>> and if not you can write a script to kill the X server after 30secs
>> after resume (and kill that script if resume succeeds).
>
> Hi Tejun & Jerome.
>
> Tejun: My script killed X after a small wait from a bad resume. I am returned
> to the funcioning calling console. I can then re-start X and all subsystems
> seem to working fine.
>
> Jerome: I posted a post-bad-resume dmesg snippet with a GPU lockup warning
> and trace here:
>
>   http://article.gmane.org/gmane.linux.kernel/1210057
>
> Did you need to see more?
>
> Thanks.
>
> ~ Andy
>
>

I need full dmesg

Cheers,
Jerome
