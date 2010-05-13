Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab0EMUPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:15:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33727 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab0EMUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:15:52 -0400
Date: Thu, 13 May 2010 21:15:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bastien Nocera <hadess@hadess.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100513201532.GA20473@srcf.ucam.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <1273762051.2308.4671.camel@localhost.localdomain> <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org> <20100513155031.GA22238@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513155031.GA22238@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:50:31AM -0700, Dmitry Torokhov wrote:

> Indeed most of them do just work. My Dell T110 for example boots just
> fine and it only has USB, no PS/2 ports. However there is a rather
> important difference I think - these other boxes are supposed to work
> with multiple versions of Windows which, as far as I know, do probe for
> the i8042. Apple only supports bootcamp on certain BIOSes and does not
> really expect anything to touch these ports.

If you're not using bootcamp then you're booting via EFI, and in that 
case I think it's probably reasonable to require that the keyboard be 
provided via PNP or flagged in the XDST.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
