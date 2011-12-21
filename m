Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1LUBLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:11:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61370 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1LUBLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:11:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111221111349.c9d73384a0a2c89cd211239e@canb.auug.org.au>
References: <20111221111349.c9d73384a0a2c89cd211239e@canb.auug.org.au>
Date: Tue, 20 Dec 2011 20:11:17 -0500
Message-ID: <CA+5PVA7NhzxwxR5WGDmUQ432NehNnzRT+y05wve+FBXHyGaiwA@mail.gmail.com>
Subject: Re: linux-next: build warnings after merge of the 4xx tree
From: Josh Boyer <jwboyer@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 7:13 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Josh,
>
> After merging the 4xx tree, today's linux-next build (powerpc ppc64_defconfig)
> produced these warnings:
>
> WARN: Uncompressed kernel (size 0xe32858) overlaps the address of the wrapper()
> WARN: Fixing the link_address of wrapper to (0xf00000)
> WARN: Uncompressed kernel (size 0xd6c9e8) overlaps the address of the wrapper(0x400000)
> WARN: Fixing the link_address of wrapper to (0xe00000)
>
> Introduced by commit c55aef0e5bc6 ("powerpc/boot: Change the load address
> for the wrapper to fit the kernel").   Maybe "WARN" is not the best
> prefix for this.  To me it implies that something may go wrong and there
> is something to be fixed ...  If this is purely informational, then maybe
> "INFO" would be better.

INFO indeed would be better.  I'll try and whip up a patch tomorrow
unless Suzie beats me to it.

Sorry about that.  I saw the WARN during my testing, but the commit
log explicitly mentioned it an brainwashed me into thinking it was OK.
 I blame holiday-itis.

josh
