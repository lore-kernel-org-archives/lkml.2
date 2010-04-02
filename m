Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab0DBHD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:03:59 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55313 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab0DBHDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:03:52 -0400
Message-ID: <4BB596CD.8060009@cs.helsinki.fi>
Date: Fri, 02 Apr 2010 10:03:41 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]slub: fix bad scope checking
References: <1270114350.2078.111.camel@ymzhang.sh.intel.com> <alpine.DEB.2.00.1004011059320.16531@router.home>
In-Reply-To: <alpine.DEB.2.00.1004011059320.16531@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 1 Apr 2010, Zhang, Yanmin wrote:
> 
>> Function init_kmem_cache_nodes is incorrect when checking upper limitation
>> of kmalloc_caches.
> 
> True.
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>

Applied, thanks!
