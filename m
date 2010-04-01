Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0DAQAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:00:21 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:38789 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab0DAQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:00:14 -0400
Date: Thu, 1 Apr 2010 11:00:09 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH]slub: fix bad scope checking
In-Reply-To: <1270114350.2078.111.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1004011059320.16531@router.home>
References: <1270114350.2078.111.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Zhang, Yanmin wrote:

> Function init_kmem_cache_nodes is incorrect when checking upper limitation
> of kmalloc_caches.

True.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

