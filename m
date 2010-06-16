Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0FPP6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:58:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:32867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab0FPP6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:58:03 -0400
Date: Wed, 16 Jun 2010 17:58:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Joe Perches <joe@perches.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] arch/cris: Remove unnecessary kmalloc casts
In-Reply-To: <20100614105930.GH32506@axis.com>
Message-ID: <alpine.LNX.2.00.1006161757480.12271@pobox.suse.cz>
References: <cover.1275968594.git.joe@perches.com> <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com> <20100614105930.GH32506@axis.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Jesper Nilsson wrote:

> On Tue, Jun 08, 2010 at 05:50:33AM +0200, Joe Perches wrote:
> > And separate declaration from allocation
> > Still no error checking on failure, but it probably doesn't matter.
> 
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
