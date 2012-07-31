Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2GaGki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:40:38 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:51652
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870Ab2GaGkh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:40:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz9371I1102I542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Singh Sandeep-B37400 <B37400@freescale.com>
To: John Stoffel <john@stoffel.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
Thread-Topic: [2/3][PATCH][v2] TDM Framework
Thread-Index: AQHNbADsHRsnZfKnik2om4CTBsszqJc9f0OAgAQPaJCAAKc3gIAAwCUg
Date: Tue, 31 Jul 2012 06:40:31 +0000
Message-ID: <3F1D9DCAAB49B94D88DBE05911FA4E6E511B76@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
	<20498.41365.853741.261834@quad.stoffel.home>
	<3F1D9DCAAB49B94D88DBE05911FA4E6E511095@039-SN1MPN1-006.039d.mgd.msft.net>
 <20502.38341.619003.356462@quad.stoffel.home>
In-Reply-To: <20502.38341.619003.356462@quad.stoffel.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: John Stoffel [mailto:john@stoffel.org] 
Sent: Monday, July 30, 2012 7:40 PM
To: Singh Sandeep-B37400
Cc: John Stoffel; linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; galak@kernel.crashing.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
Subject: RE: [2/3][PATCH][v2] TDM Framework

>>>>> "Singh" == Singh Sandeep-B37400 <B37400@freescale.com> writes:

Singh> -----Original Message-----
Singh> From: John Stoffel [mailto:john@stoffel.org]
Singh> Sent: 27 July 2012 19:42
Singh> To: Singh Sandeep-B37400
Singh> Cc: linuxppc-dev@lists.ozlabs.org; 
Singh> linux-arm-kernel@lists.infradead.org; galak@kernel.crashing.org; 
Singh> linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
Singh> Subject: Re: [2/3][PATCH][v2] TDM Framework


>> From: Sandeep Singh <Sandeep@freescale.com> TDM Framework is an 
>> attempt to provide a platform independent layer which can offer a 
>> standard interface  for TDM access to different client modules.

Singh> Please don't use TLAs (Three Letter Acronyms) like TDM without explaining the clearly and up front.  It makes it hard for anyone else who doens't know your code to look it over without having to spend lots of time poking around to figure it out from either context or somewhere else.

Singh> [Sandeep] Patch for documentation for TDM is present in this 
Singh> patch set, which explains TDM in detail. Should we do this in 
Singh> commit message too??  Link too documentation patch:
Singh> http://patchwork.ozlabs.org/patch/173680/

You should put the expansion of TDM into the initial commit message, and also into the Kconfig text, so that someone configuring the kernel has a clue what you're talking about.  
[Sandeep] Thanks for suggestion. Will take care.

Try to approach this as a brandnew user who doesn't have your knowledge of the software.  Write for the un-initiated if at all possible.


John




