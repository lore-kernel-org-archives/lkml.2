Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2HYMNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2HYMNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:13:43 -0400
Date: Sat, 25 Aug 2012 08:13:27 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Daniel Mack <zonque@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120825121326.GE20043@zod.bos.redhat.com>
References: <20120824190808.GC20043@zod.bos.redhat.com>
 <5038007E.5060505@gmail.com>
 <20120825111749.GA17048@wolff.to>
 <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
 <20120825120740.GA19539@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825120740.GA19539@wolff.to>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 07:07:40AM -0500, Bruno Wolff III wrote:
> On Sat, Aug 25, 2012 at 14:02:51 +0200,
>   Daniel Mack <zonque@gmail.com> wrote:
> >
> >Can you revert commit e9ba389c5 ("ALSA: usb-audio: Fix
> >scheduling-while-atomic bug in PCM capture stream") and see if that
> 
> I can try that, but it takes a long time to build a new kernel on my
> old hardware.

I started a scratch build of a kernel with that patch reverted (via
patch -R).  You'll find it here when it finishes:

http://koji.fedoraproject.org/koji/taskinfo?taskID=4421817

josh
