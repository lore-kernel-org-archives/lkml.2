Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767826Ab2KONmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:42:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767794Ab2KONmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:42:53 -0500
Date: Thu, 15 Nov 2012 14:42:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH] treewide: Kconfig Make EARLY_PRINTK and TTY_PRINTK
 "depends on" PRINTK
In-Reply-To: <1352829239.24230.45.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1211151442070.15877@pobox.suse.cz>
References: <1352829239.24230.45.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Joe Perches wrote:

> Add a dependency on PRINTK for these 2 CONFIG options

Hmm ... could you please make the changelog more verbose? What exactly 
implies the hard dependency, please? What can break?

-- 
Jiri Kosina
SUSE Labs
