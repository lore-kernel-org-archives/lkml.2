Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0D0Gzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 02:55:52 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:15009
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751406Ab0D0Gzu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 02:55:50 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432P98dNzz1202hzz6ff19h6d525hz32i2a8h43h65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0L1IWKP-01-F0T-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 08:55:34 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [049/197] x86, amd: Get multi-node CPU info from NodeId MSR
 instead of PCI config space
Message-ID: <20100427065534.GB6248@alberich.amd.com>
References: <20100422190911.735233389@kvm.kroah.org>
 <alpine.LNX.2.00.1004261906410.7579@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004261906410.7579@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Apr 2010 06:55:35.0029 (UTC) FILETIME=[A2C87A50:01CAE5D6]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 07:10:37PM +0200, Jiri Kosina wrote:
> On Thu, 22 Apr 2010, Greg KH wrote:
> 
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.

[...]

> 
> This patch is causing kernel panic on boot on Magny Cours CPU here (cpu 
> family 16, model 9, stepping 1).
> 
> Please see screenshot from the paniced kernel on 
> 
>    http://www.jikos.cz/jikos/junk/screenshot.jpg 
> 
> (sorry for bad quality of this screenshot, it was captured only from the 
> IPMI/HTTP console so far, I will try to grab something better tomorrow)
> 
> Also this screenshot probably doesn't show the complete picture -- see the 
> "end trace" marker on the very first line. I will try to have something 
> better tomorrow, but maybe this rings bell for someone right away.

This looks like a BIOS issue to me. Obviously this is a pre-production
test system where an old BIOS is installed. A BIOS update should fix
this issue for you.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


