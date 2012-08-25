Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2HYPCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 11:02:25 -0400
Received: from wolff.to ([65.117.131.163]:46361 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752836Ab2HYPCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 11:02:22 -0400
Date: Sat, 25 Aug 2012 10:00:33 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Daniel Mack <zonque@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120825150033.GA10578@wolff.to>
References: <20120824190808.GC20043@zod.bos.redhat.com>
 <5038007E.5060505@gmail.com>
 <20120825111749.GA17048@wolff.to>
 <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
 <20120825120740.GA19539@wolff.to>
 <20120825121326.GE20043@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20120825121326.GE20043@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 08:13:27 -0400,
   Josh Boyer <jwboyer@redhat.com> wrote:
>On Sat, Aug 25, 2012 at 07:07:40AM -0500, Bruno Wolff III wrote:
>> On Sat, Aug 25, 2012 at 14:02:51 +0200,
>>   Daniel Mack <zonque@gmail.com> wrote:
>> >
>> >Can you revert commit e9ba389c5 ("ALSA: usb-audio: Fix
>> >scheduling-while-atomic bug in PCM capture stream") and see if that
>>
>> I can try that, but it takes a long time to build a new kernel on my
>> old hardware.
>
>I started a scratch build of a kernel with that patch reverted (via
>patch -R).  You'll find it here when it finishes:
>
>http://koji.fedoraproject.org/koji/taskinfo?taskID=4421817

I tested this on two of the three (the other is at work) that I was having 
the problem on and they both work as expected now.
