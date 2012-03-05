Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2CEM5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:57:13 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:59122 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2CEM5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:57:10 -0500
Date: Mon, 5 Mar 2012 09:53:09 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] tpm_tis: fix tis_lock with respect to RCU
Message-ID: <20120305125309.GA2923@hardened-box.ibm.com>
References: <alpine.LNX.2.00.1202291026520.31150@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202291026520.31150@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030512-2194-0000-0000-00000129E029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Jiri Kosina wrote:

> cleanup_tis() -> tpm_remove_hardware() -> syncrhonize_rcu() is being 
> called in an atomic context (tis_lock spinlock held), which is not 
> allowed. Convert tis_lock to mutex.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

