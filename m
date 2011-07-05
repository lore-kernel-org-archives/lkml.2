Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1GEP4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:56:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1GEP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:56:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: OpenRISC Architecture: Patch set version 2
Date: Tue, 5 Jul 2011 17:56:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051756.33424.arnd@arndb.de>
X-Provags-ID: V02:K0:1fbiImvYL6a11Cu6NmpJHVvIRwYlcvGv5j/0NMVIWsT
 CfaOOIY1ppJpF5Uo71O/9Xpi4jUMFSXfwf2or4UourCp5Zkg1D
 mNnfb/Cm/dKymAqgh5bzbvM4yc3sCYt5bRyUEm/2H7IRLMvCVB
 6KkcR44pfaHaLQem4c//C64kGdwC458C/jwhHcYdzr3H/gSh7v
 QpMU1LA88VBN7+taYN0BA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011, Jonas Bonn wrote:
> This is version 2 of the OpenRISC architecture patch set.  Changes
> since version 1 include:
> 
> - general cleanups, removing unused code and variables, taking care of
>   compiler warnings, etc.
> - cleanups for all the errors spotted by checkpatch.pl
> - changes in response to the feedback received for version 1 of the patch set
> - simplification of the fixmap code
> - simplification of the DMA code
> - calculate loops_per_jiffy from cpu frequency passed in via devicetree
> - rework io.h to use more generic code
> - rework the delay code, making it more generic
> 
> - also, the module code has been reworked, making it more generic; this is
>   not included in this patch as the generic parts are still pending review

I think this is basically ready for inclusion in 3.1. There are a few details
that you can still improve, but I see no reason to hold up the merge into
mainline. After you have addressed the comments that are still outstanding
at this time, please add "Reviewed-by: Arnd Bergmann <arnd@arndb.de>"
to all the patches.

The most important part to work out are the device tree bindings, as discussed
for patch 2. Once you have a version of that patch that everyone is happy
with, please post the entire series including the patches that address common
code once more.

> Once again, all this code can be found in the 'for-upstream' branch at:
> 
> git://openrisc.net/jonas/linux

IMO it would be best if Stephen added that branch to linux-next right
away, so we get some test exposure on your common code changes before
the merge window.

	Arnd
