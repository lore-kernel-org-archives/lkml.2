Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2HYL4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 07:56:19 -0400
Received: from wolff.to ([65.117.131.163]:46224 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750820Ab2HYL4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 07:56:12 -0400
Date: Sat, 25 Aug 2012 06:54:23 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Daniel Mack <zonque@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120825115423.GA14327@wolff.to>
References: <20120824190808.GC20043@zod.bos.redhat.com>
 <5038007E.5060505@gmail.com>
 <20120825111749.GA17048@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20120825111749.GA17048@wolff.to>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 06:17:49 -0500,
   Bruno Wolff III <bruno@wolff.to> wrote:
>
>I see this behavior on three different computers. Rebooting into an old
>enough kernel gets things working again. The older kernels also have 
>older initramfs images. I could rebuild those to see if there is some 
>issue there instead of the kernels themselves?

I tested one of the older kernels (where the headset still worked) with a 
rebuilt initramfs and the headset still worked. So it likely isn't an issue 
with something in the initramfs images.
