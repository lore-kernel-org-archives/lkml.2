Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1ASDid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:38:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65374 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1ASDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:38:32 -0500
Date: Wed, 19 Jan 2011 01:38:31 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] bluetooth: Fix failure to release lock in
 read_index_list() when mem alloc fails.
Message-ID: <20110119033831.GB7762@joana>
References: <alpine.LNX.2.00.1101140000541.11347@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101140000541.11347@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

* Jesper Juhl <jj@chaosbits.net> [2011-01-14 00:18:49 +0100]:

> If alloc_skb() fails in read_index_list() we'll return -ENOMEM without 
> releasing 'hci_dev_list_lock'.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mgmt.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch has been applied. Thanks.

-- 
Gustavo F. Padovan
http://profusion.mobi
