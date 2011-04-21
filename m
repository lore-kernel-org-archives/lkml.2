Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1DUSp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:45:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45929 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1DUSp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:45:57 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.DEB.2.00.1104211328000.5741@router.home>
References: <1303337718.2587.51.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com>
	 <20110421221712.9184.A69D9226@jp.fujitsu.com>
	 <1303403847.4025.11.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104211328000.5741@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 21 Apr 2011 11:45:37 -0700
Message-ID: <1303411537.9048.3583.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 13:33 -0500, Christoph Lameter wrote:
> http://www.linux-mips.org/archives/linux-mips/2008-08/msg00154.html
> 
> http://mytechkorner.blogspot.com/2010/12/sparsemem.html
> 
> Dave Hansen, Mel: Can you provide us with some help? (Its Easter and so
> the europeans may be off for awhile) 

Yup, for sure.  It's also interesting how much code ppc64 removed when
they did this:

http://lists.ozlabs.org/pipermail/linuxppc64-dev/2005-November/006646.html

Please cc me on patches.  Or, if nobody else was planning on doing it, I
can take a stab at doing SPARSEMEM on one of the arches.  I won't be
able to _run_ it outside of qemu, but it might be quicker than someone
starting from scratch.

Was it really just m68k and parisc that need immediate attention?

-- Dave

