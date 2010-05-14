Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0ENOz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:55:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51838 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0ENOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:55:56 -0400
Date: Fri, 14 May 2010 15:55:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100514145539.GA5598@srcf.ucam.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done some experimentation under qemu. On ACPI systems, Windows will 
*only* touch the keyboard controller if there's a device with an 
appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
Otherwise it'll simply ignore the hardware entirely. By the looks of it 
their keyboard probing is also somewhat different to ours, but that's 
probably another story.

However, I did find a couple of device IDs that machines may produce 
which we don't currently check for. I'll send a patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
