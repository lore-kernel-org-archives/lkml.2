Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2G3J3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:29:21 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:57245
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab2G3J3U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:29:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
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
Thread-Index: AQHNbADsHRsnZfKnik2om4CTBsszqJc9f0OAgAQPaJA=
Date: Mon, 30 Jul 2012 09:29:15 +0000
Message-ID: <3F1D9DCAAB49B94D88DBE05911FA4E6E511095@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20498.41365.853741.261834@quad.stoffel.home>
In-Reply-To: <20498.41365.853741.261834@quad.stoffel.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: John Stoffel [mailto:john@stoffel.org] 
Sent: 27 July 2012 19:42
To: Singh Sandeep-B37400
Cc: linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; galak@kernel.crashing.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
Subject: Re: [2/3][PATCH][v2] TDM Framework


> From: Sandeep Singh <Sandeep@freescale.com> TDM Framework is an 
> attempt to provide a platform independent layer which can offer a 
> standard interface  for TDM access to different client modules.

Please don't use TLAs (Three Letter Acronyms) like TDM without explaining the clearly and up front.  It makes it hard for anyone else who doens't know your code to look it over without having to spend lots of time poking around to figure it out from either context or somewhere else.
[Sandeep] Patch for documentation for TDM is present in this patch set, which explains TDM in detail. Should we do this in commit message too??
Link too documentation patch: http://patchwork.ozlabs.org/patch/173680/

John


