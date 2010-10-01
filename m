Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0JAS4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:56:39 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38096 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754866Ab0JAS4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:56:38 -0400
Date: Fri, 1 Oct 2010 13:56:37 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: Re: [PATCH 7/9] v3 Define memory_block_size_bytes for
 powerpc/pseries
Message-ID: <20101001185637.GN14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
 <4CA62A0A.4050406@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA62A0A.4050406@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:35:54PM -0500, Nathan Fontenot wrote:
> Define a version of memory_block_size_bytes() for powerpc/pseries such that
> a memory block spans an entire lmb.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Reviewed-by: Robin Holt <holt@sgi.com>
