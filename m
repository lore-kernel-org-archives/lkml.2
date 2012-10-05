Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2JEQbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:31:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:57875 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2JEQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:22:28 -0400
Message-ID: <1349454169.3106.6.camel@clam>
Subject: Re: [Cbe-oss-dev] [PATCH 4/5] Rename the drivers/of prom_*
	functions to of_*
From: Geoff Levand <geoff@infradead.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Date: Fri, 05 Oct 2012 09:22:49 -0700
In-Reply-To: <506BA9E6.9050309@linux.vnet.ibm.com>
References: <506B2E63.5090900@linux.vnet.ibm.com>
	 <506BA9E6.9050309@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 21:58 -0500, Nathan Fontenot wrote:
> Rename the prom_*_property routines of the generic OF code to of_*_property.
> This brings them in line with the naming used by the rest of the OF code.
> 
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/ps3/os-area.c      |    6 +++---
>  10 files changed, 35 insertions(+), 37 deletions(-)

The ps3 part looks OK.  Please do build test with ps3_defconfig.

Acked-by: Geoff Levand <geoff@infradead.org>

