Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab1ELK06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:26:58 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:55085 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1ELK05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:26:57 -0400
Date: Thu, 12 May 2011 12:25:15 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from online_page()
Message-ID: <20110512102515.GA27851@router-fw-old.local.net-space.pl>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105111547160.24003@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105111547160.24003@chino.kir.corp.google.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:47:49PM -0700, David Rientjes wrote:
> On Mon, 2 May 2011, Daniel Kiper wrote:
>
> > Memory hotplug code strictly depends on CONFIG_SPARSEMEM.
> > It means that code depending on CONFIG_FLATMEM in online_page()
> > is never compiled. Remove it because it is not needed anymore.
> >
> > Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
>
> The code you're patching depends on CONFIG_MEMORY_HOTPLUG_SPARSE, so this
> is valid.  The changelog should be updated to reflect that, however.
>
> Acked-by: David Rientjes <rientjes@google.com>

No problem, however, this bundle of patches was added to the -mm tree.
In this situation should I repost whole bundle with relevant changes
or post only those two patches requested by you ??? For which tree
should I prepare new version of patches ???

Daniel
