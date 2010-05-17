Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0EQQq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:46:56 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27083 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab0EQQqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:46:54 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432P98dN1b0bMzz1202hzz5eeeP3198r327alz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L2KP9Z-02-JS4-02
X-M-MSG: 
Date: Mon, 17 May 2010 18:46:44 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>,
       "markh@compro.net" <markh@compro.net>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "alain@knaff.lu" <alain@knaff.lu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <20100517164644.GW5888@alberich.amd.com>
References: <4B32565E.6000501@compro.net>
 <20091223191806.GA3336@linux-os.sc.intel.com>
 <4B3270FE.5090607@compro.net>
 <1261600243.16916.56.camel@localhost.localdomain>
 <4B476E8D.1030308@compro.net>
 <20100121190952.GA32523@linux-os.sc.intel.com>
 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
 <20100125171059.GB5041@alberich.amd.com>
 <20100517145943.GV5888@alberich.amd.com>
 <alpine.LFD.2.00.1005170811400.4195@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005170811400.4195@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 11:12:59AM -0400, Linus Torvalds wrote:
> 
> 
> On Mon, 17 May 2010, Andreas Herrmann wrote:
> > 
> > FYI. I've tried to trigger the publication of errata information for that
> > chipset. Finally this has happened.
> > 
> > The discussed problem is indeed due to an erratum. See erratum #27 in
> > http://support.amd.com/us/Embedded_TechDocs/46837.pdf
> > 
> > The suggested workaround for this is to disable HPET MSI if LPC
> > devices are used. I doubt that there is a convenient way for Linux to
> > find out whether LPC devices are used. Thus I think the only solution
> > to safely avoid the problem is the currently implemented quirk to
> > disable HPET MSI on this chipset.
> 
> Goodie. It would be good to point this out in the source too. Would you be 
> willing to send in a patch that documents this quirk as a result of that 
> erratum #27, so that we don't lose sight of why we're doing that odd MSI 
> disable?

Done that.
See http://marc.info/?l=linux-kernel&m=127411462230838


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


