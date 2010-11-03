Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab0KCSgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:36:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40022 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab0KCSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:36:18 -0400
Date: Wed, 3 Nov 2010 14:36:30 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: cmtp: fix information leak to userland
Message-ID: <20101103183630.GC17943@vigoh>
References: <1288448787-5848-1-git-send-email-segooon@gmail.com>
 <1288712158.3322.179.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288712158.3322.179.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marcel Holtmann <marcel@holtmann.org> [2010-11-02 16:35:58 +0100]:

> Hi Vasiliy,
> 
> > Structure cmtp_conninfo is copied to userland with some padding fields
> > unitialized.  It leads to leaking of contents of kernel stack memory.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Applied, thanks.  

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
