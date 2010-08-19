Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0HSIzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:55:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:58861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab0HSIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:55:18 -0400
Date: Thu, 19 Aug 2010 10:55:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tao Ma <tao.ma@oracle.com>, linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] trivial: Use kzalloc in idedisk_prep_fn.
In-Reply-To: <4C6CD610.3090902@garzik.org>
Message-ID: <alpine.LNX.2.00.1008191055080.1019@pobox.suse.cz>
References: <1282190541-12154-1-git-send-email-tao.ma@oracle.com> <4C6CD610.3090902@garzik.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, Jeff Garzik wrote:

> > Cc: Jiri Kosina<trivial@kernel.org>
> > Signed-off-by: Tao Ma<tao.ma@oracle.com>
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
