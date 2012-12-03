Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2LCANz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 19:13:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63735 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2LCANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 19:13:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121128.214732.1634269294133625782.davem@davemloft.net>
References: <20121128.214732.1634269294133625782.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 2 Dec 2012 16:13:30 -0800
X-Google-Sender-Auth: vN3A4JgCx9bo-DjUn9Xty6KuHF0
Message-ID: <CA+55aFy1sa=D-DrWqNuvjrLW8J0Tw1+GbZhXv6VHTTTxXG_DMA@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Willy pointed me to the recent splice crash fix
(do_tcp_sendpages and non-0-order pages). It's apparently easily
user-triggerable.. Should I take the patch directly, or do you have a
tree to pull. Don't want to make a release with a known oopser..

          Linus
