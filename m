Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1LLV1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:27:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18512 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1LLV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:27:04 -0500
Date: Mon, 12 Dec 2011 16:26:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 12
Message-ID: <20111212212604.GA11844@phenom.dumpdata.com>
References: <20111212161444.22a11535656c6bfbd884d9ec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212161444.22a11535656c6bfbd884d9ec@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4EE671A3.008B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 04:14:44PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20111209:
> 
> New tree: remoteproc
> 
> Removed tree: arm-lpae (its job is done)
> 
> The drm tree gained a conflict against Linus' tree.

Using wholesale the drm tree for the rivers/gpu/drm/nouveau/nouveau_sgdma.c
is the right approach. I tried to create a patch to send to you for it (by
merging drm-next against Linus' tree and running mergetool) - but I don't seem
to get anything out of it (just some fix to the Intel driver).

