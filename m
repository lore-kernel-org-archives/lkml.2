Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0LaRrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:47:05 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58864 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab0LaRrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:47:02 -0500
Date: Fri, 31 Dec 2010 09:46:58 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] UDPCP Communication Protocol
Message-ID: <20101231094658.1881c113@s6510>
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010 10:29:45 +0100
stefani@seibold.net wrote:

> +/*
> + * UDPCP destination descriptor
> + *
> + * For each communication address an individual destination descriptor will
> + * be create.
> + *
> + * The fields has the following meanings:
> + *
> + * list:		link list: part of udpcp_sock.destlist
> + * xmit:		messages fragments to be transmit
> + * tx_time:		timestamp of the last transmitted message fragment
> + * rx_time:		timestamp ot the last received message fragment
> + * txTimeout:		statistic use only: number of transmit timeout
> + * rxTimeout:		statistic use only: number of receive timeout
> + * txRetries:		statistic use only: number of transmit retries
> + * rxDiscardedFrags:	statistic use only: number of discarded messages
> + * xmit_wait:		message fragment which is waiting for an ACK
> + * xmit_last:		last fragment transmitted
> + * recv_msg:		first fragment of the received message
> + * recv_last:		last fragment of the received message
> + * lastmsg:		last messages fragment header received
> + * ipc:			linux internal ipc cookie
> + * fl:			flow/routing information
> + * rt:			routing entry currently used for this destination
> + * addr:		ipv4 destination address
> + * port:		destination port number
> + * msgid:		current message id for outgoing data messages
> + * use_flag:		statistic use only: flag for dest using TX and/or RX
> + * insync:		flag for protocol synchronization
> + * ackmode;		ack mode for the current assembled message
> + * chkmode;		checksum mode for the current assembled message
> + * try:			current number of retries xmit_wait message
> + * acks:		number of outstandig ack's
> + */

Why not use docbook format comments for this?
