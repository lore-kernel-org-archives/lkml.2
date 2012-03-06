Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab2CFCrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 21:47:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241Ab2CFCra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 21:47:30 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=L9yuZz8AkGsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=nDqDNAa9K7cn--F23vQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331002048.25686.354.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/6] Netfilter: xt_LOG: Implement ring buffer support
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Weinberger <richard@nod.at>
Cc: pablo@netfilter.org, jengelh@medozas.de, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Date: Mon, 05 Mar 2012 21:47:28 -0500
In-Reply-To: <1330989588-26833-6-git-send-email-richard@nod.at>
References: <1330989588-26833-1-git-send-email-richard@nod.at>
	 <1330989588-26833-6-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 00:19 +0100, Richard Weinberger wrote:
> This patch introduces NETFILTER_XT_TARGET_LOG_RING.
> It allows logging into various ring buffers which are
> represented as pipe-like files in /proc/net/netfilter/nf_log_ring/.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


