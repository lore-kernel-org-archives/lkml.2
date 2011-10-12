Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1JLPwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:52:39 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54533 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1JLPwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:52:38 -0400
Date: Wed, 12 Oct 2011 08:52:35 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Muraliraja Muniraju <muralira@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] net-netlink: Add a new attribute to expose TOS
 values via netlink
Message-ID: <20111012085235.3b78729b@nehalam.linuxnetplumber.net>
In-Reply-To: <1318382887-31824-1-git-send-email-muralira@google.com>
References: <20111010145206.6f7e9ee2@nehalam.linuxnetplumber.net>
	<1318382887-31824-1-git-send-email-muralira@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011 18:28:07 -0700
Muraliraja Muniraju <muralira@google.com> wrote:

> +/* INET_DIAG_TOS */
> +
> +struct inet_diag_tos {
> +	__u8	idiag_tos;
> +};
> +

This structure is not used.
