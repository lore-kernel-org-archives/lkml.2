Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab2CENFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:05:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024Ab2CENFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:05:49 -0500
Date: Mon, 5 Mar 2012 14:05:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] tpm_tis: fix tis_lock with respect to RCU
In-Reply-To: <20120305125309.GA2923@hardened-box.ibm.com>
Message-ID: <alpine.LNX.2.00.1203051405320.23367@pobox.suse.cz>
References: <alpine.LNX.2.00.1202291026520.31150@pobox.suse.cz> <20120305125309.GA2923@hardened-box.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, Rajiv Andrade wrote:

> > cleanup_tis() -> tpm_remove_hardware() -> syncrhonize_rcu() is being 
> > called in an atomic context (tis_lock spinlock held), which is not 
> > allowed. Convert tis_lock to mutex.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Okay, thanks. I am taking this through trivial.git then.

-- 
Jiri Kosina
SUSE Labs
