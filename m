Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031431Ab2COPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:51:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44592 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030550Ab2COPvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <s5hy5r1vpch.wl%tiwai@suse.de>
References: <CA+1xoqfKE2u7mm=o507TvoFw8oqtKq8RRaJ5jU4c=J-GAH0APw@mail.gmail.com>
 <s5h4ntpx4hk.wl%tiwai@suse.de> <CA+1xoqeL96L9SvtQ2ckXez-Kye4D9qRhuREd9Bq97wGU468R3w@mail.gmail.com>
 <s5hy5r1vpch.wl%tiwai@suse.de>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 15 Mar 2012 17:50:55 +0200
Message-ID: <CA+1xoqfR6K=Hw+kWMUncXQj74EYDOj6f4gAnJzetCHjv2s+xow@mail.gmail.com>
Subject: Re: sound: BUG: unable to handle kernel irq event stamp: 2013419
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, lucas.demarchi@profusion.mobi,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 5:46 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 15 Mar 2012 17:36:44 +0200,
> Sasha Levin wrote:
>>
>> On Thu, Mar 15, 2012 at 5:34 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > The bug seems coming from the old OSS driver.  Do you enable any OSS
>> > drivers?
>>
>> They're most likely compiled in (kernel is pretty close to a 'make
>> allyesconfig'), but I haven't done anything in particular to start
>> them.
>
> What does trinity at all?

It's a syscall fuzzer which can be found here:
codemonkey.org.uk/projects/trinity/trinity.git
