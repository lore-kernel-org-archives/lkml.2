Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1BNOfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:35:09 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36851 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1BNOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:35:07 -0500
Date: Mon, 14 Feb 2011 12:35:32 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] bluetooth: bnep: fix buffer overflow
Message-ID: <20110214143532.GA2597@joana>
References: <1297680871-11617-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297680871-11617-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

* Vasiliy Kulikov <segoon@openwall.com> [2011-02-14 13:54:31 +0300]:

> Struct ca is copied from userspace.  It is not checked whether the "device"
> field is NULL terminated.  This potentially leads to BUG() inside of
> alloc_netdev_mqs() and/or information leak by creating a device with a name
> made of contents of kernel stack.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested.
> 
>  net/bluetooth/bnep/sock.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

-- 
Gustavo F. Padovan
http://profusion.mobi
