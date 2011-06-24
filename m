Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1FXLz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:55:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1FXLz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:55:58 -0400
Date: Fri, 24 Jun 2011 13:55:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaliy Ivanov <vitalivanov@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the trivial tree with the s390
 tree
In-Reply-To: <20110621133740.b23b87d4.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1106241354520.11049@pobox.suse.cz>
References: <20110621133740.b23b87d4.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/s390/kvm/sie64a.S between commit 57e98c34511e ("[S390] move sie code
> to entry.S") from the s390 tree and commit e44ba033c565 ("treewide:
> remove duplicate includes") from the trivial tree.
> 
> The former merged this file into another file, so I just removed this file.

Thanks for reporting, I have dropped the hunk.

-- 
Jiri Kosina
SUSE Labs
