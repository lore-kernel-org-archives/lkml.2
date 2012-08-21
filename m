Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2HUVyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:54:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45285 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab2HUVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:54:53 -0400
Date: Tue, 21 Aug 2012 14:54:52 -0700 (PDT)
Message-Id: <20120821.145452.1762302256533324265.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: rjw@sisk.pl, stern@rowland.harvard.edu, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: fix generic_ide_suspend/resume Oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <87txvwgtkx.fsf@tucsk.pomaz.szeredi.hu>
References: <87txvwgtkx.fsf@tucsk.pomaz.szeredi.hu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 21 Aug 2012 17:20:30 +0200

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This patch fixes a regresion introduced by commit 0998d063 (device-core: Ensure
> drvdata = NULL when no driver is bound).
> 
> Suspend oopses in generic_ide_suspend() because dev_get_drvdata()
> returns NULL (dev->p->driver_data == NULL) and this function is not
> prepared for this.
> 
> Fix is based on Alan Stern's suggestion.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied, thanks.
