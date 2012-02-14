Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2BNAFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:05:42 -0500
Received: from mail.us.es ([193.147.175.20]:42698 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab2BNAFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:05:40 -0500
Date: Tue, 14 Feb 2012 01:05:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org, basti@b-bl.de
Subject: Re: [PATCH 2/4] ring_buffer: Export for_each_buffer_cpu()
Message-ID: <20120214000538.GB24029@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-5-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328911856-19260-5-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:10:54PM +0100, Richard Weinberger wrote:
> In order to make ring_buffer usable to other modules
> for_each_buffer_cpu() needs to be exported.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I've taken this one as well since we need it for the ring_buffer
support for your extension for xt_LOG.
