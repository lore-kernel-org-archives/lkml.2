Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GSLpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:45:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1GSLph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:45:37 -0400
Date: Tue, 19 Jul 2011 04:37:06 -0700
From: Greg KH <gregkh@suse.de>
To: wangyanqing <udknight@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers:net:Kconfig
Message-ID: <20110719113706.GA18436@suse.de>
References: <20110719090014.GA5455@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719090014.GA5455@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 05:00:14PM +0800, wangyanqing wrote:
>  Broadcom Tigon3 driver tg3.ko can't work without the Broadcom PHY,
>  so maybe we should add a dependence on it.Or at least we should add
>  notice in the help txt.
> 
> Signed-off-by: wang yanqing <udknight@gmail.com>
> ---
>  drivers/net/Kconfig |    2 +-

Ok, but why in the world would you send this patch to me?

confused,

greg k-h
