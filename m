Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1KTTdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 14:33:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab1KTTdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 14:33:08 -0500
Date: Sun, 20 Nov 2011 20:33:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Anders Larsen <al@alarsen.net>
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qnx4fs: Use kmemdup rather than duplicating its
 implementation
In-Reply-To: <201111201335.57713.al@alarsen.net>
Message-ID: <alpine.LNX.2.00.1111202032400.15187@pobox.suse.cz>
References: <201111201335.57713.al@alarsen.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Nov 2011, Anders Larsen wrote:

> From: Thomas Meyer <thomas@m3y3r.de>
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> Signed-off-by: Anders Larsen <al@alarsen.net>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
