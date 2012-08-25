Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2HYMJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:09:38 -0400
Received: from wolff.to ([65.117.131.163]:46239 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753805Ab2HYMJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:09:29 -0400
Date: Sat, 25 Aug 2012 07:07:40 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Daniel Mack <zonque@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120825120740.GA19539@wolff.to>
References: <20120824190808.GC20043@zod.bos.redhat.com>
 <5038007E.5060505@gmail.com>
 <20120825111749.GA17048@wolff.to>
 <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5038BEEB.6090303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 14:02:51 +0200,
   Daniel Mack <zonque@gmail.com> wrote:
>
>Can you revert commit e9ba389c5 ("ALSA: usb-audio: Fix
>scheduling-while-atomic bug in PCM capture stream") and see if that

I can try that, but it takes a long time to build a new kernel on my 
old hardware.

>helps? If not, can you summarize again which kernels still work for you
>and which don't?

The latest kernel that works is 3.6.0-0.rc2.git1.2.fc18. The earliest that 
doesn't work is 3.6.0-0.rc2.git2.1.fc18.
