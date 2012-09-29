Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab2I2HaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:30:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49702 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab2I2HaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:30:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 08/12] dtc: be more quiet with "make -s"
Date: Sat, 29 Sep 2012 07:27:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        David Gibson <dwg@au1.ibm.com>, arm@kernel.org
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-9-git-send-email-arnd@arndb.de> <50661CC6.2010007@wwwdotorg.org>
In-Reply-To: <50661CC6.2010007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209290727.41798.arnd@arndb.de>
X-Provags-ID: V02:K0:wi7CsNTmSLpOtcqdCIOYfzi3U8x+QR9gPc8z71viptk
 9/Cr3VauJAn43/RHEBNkKksVdtxbZk7+lyfiR2zrk/hny9C6pp
 GUMluwykC/gRDwB9xuC99Gphd/wL1hIsoX3KEBQPcftePlr49Z
 WQVk06VtLevUh2OoW8Hvvr9sTBYur/WCvDmnmt4BfCnRQii5Ja
 Kic+fE+qmsu15u/oM8I3iob17gvMLuUHgaBh+JCrPTY3+zsDtf
 Lsft3fX1mCP+gn67KUTDxSxyMfDUYkxl1OkKeErbEAtqKAWpvZ
 oQD1KzbatSg31sOYDDGUvaG73RloPjxgViL8/fatEqxfqqt5IQ
 1o7U/c1zDJ+umOkQZBhw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2012, Stephen Warren wrote:
> On 09/28/2012 03:36 PM, Arnd Bergmann wrote:
> > This patch makes dtc not output the message when the "-q" flag is passed,
> > and ensures that we pass it in both cases.
> 
> Just as an FYI, the upstream dtc no longer prints this message, and I
> just posted a patch to pull that whole upstream dtc into the kernel.

Ok, excellent!

Michal, please ignore my patch then.

	Arnd
