Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab2BYNiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 08:38:21 -0500
Received: from mail.us.es ([193.147.175.20]:58847 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab2BYNiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 08:38:18 -0500
Date: Sat, 25 Feb 2012 14:38:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org, basti@b-bl.de
Subject: Re: [PATCH 1/2] iptables: Merge libip6t_LOG and libipt_LOG into
 libxt_LOG
Message-ID: <20120225133816.GA15864@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328911856-19260-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:10:51PM +0100, Richard Weinberger wrote:
> libip6t_LOG and libipt_LOG share a lot of common code, merge them
> to recude duplicate code.

I have applied this to the net-next branch of iptables.

See git.netfilter.org

I'll merge it to master once linux kernel 3.3 is released.

Please, send follow up patches if you find any issue. Thanks.
