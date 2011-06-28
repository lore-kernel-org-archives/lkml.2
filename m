Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1F1SAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:00:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37253 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab1F1R7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:59:16 -0400
Date: Tue, 28 Jun 2011 14:59:37 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: marcel@holtmann.org, davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] Bluetooth: Prevent buffer overflow in l2cap config
 request
Message-ID: <20110628175937.GA23183@joana>
Mail-Followup-To: Dan Rosenberg <drosenberg@vsecurity.com>,
	marcel@holtmann.org, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <1308919085.5295.11.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308919085.5295.11.camel@dan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

* Dan Rosenberg <drosenberg@vsecurity.com> [2011-06-24 08:38:05 -0400]:

> A remote user can provide a small value for the command size field in
> the command header of an l2cap configuration request, resulting in an
> integer underflow when subtracting the size of the configuration request
> header.  This results in copying a very large amount of data via
> memcpy() and destroying the kernel heap.  Check for underflow.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Cc: stable <stable@kernel.org>
> ---
>  net/bluetooth/l2cap_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

	Gustavo
