Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1BYIO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:14:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1BYIO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:14:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH] ipmi: convert OF driver to platform driver
Date: Thu, 24 Feb 2011 15:34:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Christian Krafft <parabelboi@bopserverein.de>
References: <1298497079-20546-1-git-send-email-robherring2@gmail.com> <20110224031528.GB12139@angua.secretlab.ca>
In-Reply-To: <20110224031528.GB12139@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241534.50886.arnd@arndb.de>
X-Provags-ID: V02:K0:LdchCuDgXYaHD/bSm51ia2cyMOh+y5F0nfhfj9EMUUN
 CmOQRpUia4qzNYblbXATEqfHre5UE4pLv2fHicOrXZ/RZ7TkZM
 pKe5Kbn1vU67dyCgXwakGShHZ8cuOphyzDNUANhB5ASM3f9MID
 ICZyMzzKz2BmMwVSnV25jDeqMRwibqrJMm0+l56JCkcNUU9F1D
 VKdRgWaWR1eMJdK3F/y/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 February 2011, Grant Likely wrote:
> On Wed, Feb 23, 2011 at 03:37:59PM -0600, Rob Herring wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > of_bus is deprecated in favor of the plain platform bus. This patch
> > merges the ipmi OF driver with the existing platform driver.
> > 
> > CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
> > 
> > Compile tested with and without CONFIG_OF. Tested OF probe and
> > default probe cases.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> 
> Wow.  That driver does some weird things with the driver model that
> really should be cleaned up.  That said, this change looks correct.
> I'll add it to my tree and see how it goes.

Please keep me in the look when you want to do further into cleaning
this up. The OF code was initially done for the QS21 running SLOF, and
predates the flattened device tree specs.

I don't know if Christian still remembers the code, but it might
be worthwhile having him on Cc as well.

	Arnd

