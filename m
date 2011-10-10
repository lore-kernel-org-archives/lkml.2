Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1JJUHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:07:18 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56693 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1JJUHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:07:16 -0400
Date: Mon, 10 Oct 2011 13:07:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Muraliraja Muniraju <muralira@google.com>
Cc: "David S. Miller\"" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net-netlink: Add a new attribute to expose TOS values
 via netlink
Message-ID: <20111010130713.6df8bfe4@nehalam.linuxnetplumber.net>
In-Reply-To: <1318272866-18082-1-git-send-email-muralira@google.com>
References: <1318272866-18082-1-git-send-email-muralira@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 11:54:26 -0700
Muraliraja Muniraju <muralira@google.com> wrote:

>  
> +/* INET_DIAG_TOS */
> +
> +struct inet_diag_tos {
> +	__u8	idiag_tos;
> +	__u8	idiag_reserved[3];
> +};

No reserved bytes in netlink messages please.
