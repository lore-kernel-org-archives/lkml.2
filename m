Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2BNAMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:12:55 -0500
Received: from mail.us.es ([193.147.175.20]:43239 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569Ab2BNAMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:12:51 -0500
Date: Tue, 14 Feb 2012 01:12:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org, basti@b-bl.de
Subject: Re: [PATCH 3/4] xt_log: Make printk() in sb_close() optional
Message-ID: <20120214001248.GB24194@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-6-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328911856-19260-6-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:10:55PM +0100, Richard Weinberger wrote:
> Make printk() in sb_close() optional such that other modules
> can build a log string without printing it using printk().

Applied, thanks.
