Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1B1Hld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 02:41:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53386 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1B1Hlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 02:41:32 -0500
Date: Mon, 28 Feb 2011 00:41:28 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 06/15] dt: xilinx_hwicap: merge platform and
 of_platformdriver bindings
Message-ID: <20110228074128.GB7855@angua.secretlab.ca>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
 <20110223043405.20795.19903.stgit@localhost6.localdomain6>
 <8da12938-78ee-4a0f-b1e4-7bfac7fa16c3@VA3EHSMHS036.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8da12938-78ee-4a0f-b1e4-7bfac7fa16c3@VA3EHSMHS036.ehs.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:25:22AM -0800, Stephen Neuendorffer wrote:
> Minor nit below
> 
> Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
> 
> Steve
> 
> > +#ifdef CONFIG_OF
> >  /* Match table for of_platform binding */
> 
> Does the comment still make sense?

Fixed, thanks.

