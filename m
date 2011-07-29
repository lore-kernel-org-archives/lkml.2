Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1G2WBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:01:44 -0400
Received: from mail.wdtv.com ([66.118.69.84]:38472 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab1G2WBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:01:43 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Keith Packard <keithp@keithp.com>, Ben Brewer <ben.brewer@codethink.co.uk>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: i915 SSC Patch
Date: Fri, 29 Jul 2011 18:01:39 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos2.pae.bfs; KDE/4.6.5; i686; ; )
References: <4E32ADC7.3080002@codethink.co.uk> <yunwrf1gc3b.fsf@aiko.keithp.com>
In-Reply-To: <yunwrf1gc3b.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201107291801.40049.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 29, 2011, Keith Packard wrote:
>On Fri, 29 Jul 2011 13:55:35 +0100, Ben Brewer 
<ben.brewer@codethink.co.uk> wrote:
>> I've added a global SSC (Spread Spectrum Clock) parameter to the i915
>> driver, since having SSC enabled breaks (distorts) VGA output on some
>> Core i5/i7 chips (see
>> https://bugs.freedesktop.org/show_bug.cgi?id=38750). SSC is still
>> enabled by default so the behaviour won't change but setting the
>> global_use_ssc parameter will turn this feature off and allow affected
>> devices to function correctly (notably the Dell Vostro 3300).
>
>The question I have is why is SSC enabled on the VGA output at all? I
>don't see any way VGA could ever tolerate it.

Something does not make sense here Keith, so I'm with you, and my 
background is from about 60 years in tv maintenance and 45 in broadcasting.

A pure digital output, where its a high speed serial transfer of bytes to 
the monitor, is generally not going to be sensitive the any SS used unless 
the baud rate slams around too much on a byte to byte basis.  Since SS is 
generally just a few percent, even that should not be a problem.  But 
feeding analog signals up a video cable to a vga monitor, and the pixel 
time is wobbling by 2 to 5% and you won't have much of a viewable image 
left.  The analog signals, vga etc, needs their own video clock, a dead 
stable one.

We used to spend $10k-30k$ just so we could take the signal from a 
mechanically unstable vcr that only cost us $10k, and make it stable enough 
to work on your home tv's without the top of the pix waving around like 
hurricane Katrina was in the neighborhood.

Hardware design error in the Dell?

Cheers, gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Apathy is not the problem, it's the solution"
