Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1ATXMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:12:15 -0500
Received: from tundra.namei.org ([65.99.196.166]:47762 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1ATXMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:12:14 -0500
Date: Fri, 21 Jan 2011 10:11:44 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] tpm: fix panic caused by "tpm: Autodetect itpm
 devices"
In-Reply-To: <4D388271.50404@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1101211002490.13919@tundra.namei.org>
References: <1294370641-6791-1-git-send-email-olof@lixom.net> <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com> <4D388271.50404@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Rajiv Andrade wrote:

> On 01/20/2011 03:37 PM, Olof Johansson wrote:
> > Are all TPM maintainers MIA? This is a trivial patch that fixes a
> > panic, and it was a late-added regression in 2.6.37.
> > 
> Not myself. I missed this one unfortunately in my work queue, sorry, will keep
> alert to avoid this happening again.
> 
> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Rajiv,

I've mentioned this at least once before: as maintainer of TPM, ideally, 
what you should be doing is collecting the TPM patches, testing them in 
your own tree, then pushing them to me with an indication of where they 
need to end up (e.g. bugfixes for current linus vs. next), preferably via 
git.

This is a significant part of what distinguishes maintainership from 
simply developing or reviewing code.


- James
-- 
James Morris
<jmorris@namei.org>
