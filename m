Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2G3OLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:11:32 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:54901 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2G3OLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:11:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20502.38341.619003.356462@quad.stoffel.home>
Date: Mon, 30 Jul 2012 10:10:13 -0400
From: "John Stoffel" <john@stoffel.org>
To: Singh Sandeep-B37400 <B37400@freescale.com>
Cc: John Stoffel <john@stoffel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
In-Reply-To: <3F1D9DCAAB49B94D88DBE05911FA4E6E511095@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
	<20498.41365.853741.261834@quad.stoffel.home>
	<3F1D9DCAAB49B94D88DBE05911FA4E6E511095@039-SN1MPN1-006.039d.mgd.msft.net>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Singh" == Singh Sandeep-B37400 <B37400@freescale.com> writes:

Singh> -----Original Message-----
Singh> From: John Stoffel [mailto:john@stoffel.org] 
Singh> Sent: 27 July 2012 19:42
Singh> To: Singh Sandeep-B37400
Singh> Cc: linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; galak@kernel.crashing.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
Singh> Subject: Re: [2/3][PATCH][v2] TDM Framework


>> From: Sandeep Singh <Sandeep@freescale.com> TDM Framework is an 
>> attempt to provide a platform independent layer which can offer a 
>> standard interface  for TDM access to different client modules.

Singh> Please don't use TLAs (Three Letter Acronyms) like TDM without explaining the clearly and up front.  It makes it hard for anyone else who doens't know your code to look it over without having to spend lots of time poking around to figure it out from either context or somewhere else.

Singh> [Sandeep] Patch for documentation for TDM is present in this
Singh> patch set, which explains TDM in detail. Should we do this in
Singh> commit message too??  Link too documentation patch:
Singh> http://patchwork.ozlabs.org/patch/173680/

You should put the expansion of TDM into the initial commit message,
and also into the Kconfig text, so that someone configuring the kernel
has a clue what you're talking about.  

Try to approach this as a brandnew user who doesn't have your
knowledge of the software.  Write for the un-initiated if at all
possible.

John


