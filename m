Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0HQR34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:29:56 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:38881 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751536Ab0HQR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:29:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: iwA4LZgVM1mh_JuDFAagby4wjCNmgwx9kQ9_zaAPPKn_tzR
 9sG_xb1e0luGjEgd3jUlcGPyU4lxXndrExYfa2t_hd1HTNlkjQu7yZhBEgub
 3jQ2t7yBcuD8M05yVnUpnj0wVx7kt19OUb0Jq_SDL5n7Ay6pfOgC7X_LAFU8
 QvPZZV0JsyVNZAoX4azfd3YMC2b49hgdT7cSEHA5QgDqcgyllCsL.p404fPI
 U
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 Aug 2010 12:29:48 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008171217440.11915@router.home>
Message-ID: <alpine.DEB.2.00.1008171229070.12188@router.home>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com> <alpine.DEB.2.00.1008051231400.6787@router.home>
 <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171217440.11915@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Christoph Lameter wrote:

> > I'm really curious why nobody else ran into this problem before,
> > especially if they have CONFIG_SLUB_DEBUG enabled so
> > struct kmem_cache_node has the same size.  Perhaps my early bug report
> > caused people not to test the series...
>
> Which patches were applied?


If you do not apply all patches then you can be at a stage were
kmalloc_caches[0] is still used for kmem_cache_node. Then things break.
