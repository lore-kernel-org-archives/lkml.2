Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422703Ab2CPLKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:10:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422674Ab2CPLKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:10:30 -0400
Date: Fri, 16 Mar 2012 12:10:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the trivial tree with the powerpc
 tree
In-Reply-To: <20120316145658.3fb06c5213dbca29d6898c4b@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1203161210030.18356@pobox.suse.cz>
References: <20120316145658.3fb06c5213dbca29d6898c4b@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> drivers/char/viotape.c between commit ba7a4822b48f ("powerpc: Remove some
> of the legacy iSeries specific device drivers") from the powerpc tree and
> commit a7ccf3775219 ("char: Fix typo in viotape.c") from the trivial tree.

Dropped a7ccf3775219 in my tree, thanks for report Stephen.

-- 
Jiri Kosina
SUSE Labs
