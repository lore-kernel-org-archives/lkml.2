Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0KCShO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:37:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56106 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0KCShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:37:08 -0400
Date: Wed, 3 Nov 2010 14:37:17 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Michael Poole <mdpoole@troilus.org>,
        Bastien Nocera <hadess@hadess.net>, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: hidp: fix information leak to userland
Message-ID: <20101103183717.GD17943@vigoh>
References: <1288448791-6009-1-git-send-email-segooon@gmail.com>
 <1288712189.3322.180.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288712189.3322.180.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marcel Holtmann <marcel@holtmann.org> [2010-11-02 16:36:29 +0100]:

> Hi Vasiliy,
> 
> > Structure hidp_conninfo is copied to userland with version, product,
> > vendor and name fields unitialized if both session->input and session->hid
> > are NULL.  It leads to leaking of contents of kernel stack memory.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Applied, thanks.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
