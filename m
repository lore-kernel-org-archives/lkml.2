Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2CIMpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:45:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2CIMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:45:41 -0500
Date: Fri, 9 Mar 2012 09:45:19 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: marcel@holtmann.org, davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Resend: [PATCH] Bluetooth: Fix Endian Bug.
Message-ID: <20120309124512.GF16366@joana>
Mail-Followup-To: santosh nayak <santoshprasadnayak@gmail.com>,
	marcel@holtmann.org, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrei,

* santosh nayak <santoshprasadnayak@gmail.com> [2012-03-01 22:46:36 +0530]:

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Fix network to host endian conversion for L2CAP chan id.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  net/bluetooth/l2cap_sock.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

Applied, thanks.

	Gustavo
