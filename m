Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab2BMX4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:56:49 -0500
Received: from mail.us.es ([193.147.175.20]:42203 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344Ab2BMX4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:56:45 -0500
Date: Tue, 14 Feb 2012 00:56:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org, basti@b-bl.de
Subject: Re: [PATCH 1/4] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
Message-ID: <20120213235642.GA24029@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-3-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328911856-19260-3-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:10:52PM +0100, Richard Weinberger wrote:
> ipt_LOG and ip6_LOG have a lot of common code, merge them
> to reduce duplicate code.

Applied, thanks.
