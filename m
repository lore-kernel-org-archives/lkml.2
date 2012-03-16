Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946274Ab2CPXtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:49:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946257Ab2CPXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:49:13 -0400
Date: Fri, 16 Mar 2012 16:49:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCHv2 3/3] simple_open: Automatically convert to
 simple_open()
Message-Id: <20120316164911.dbc089de.akpm@linux-foundation.org>
In-Reply-To: <1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
References: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
	<1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 02:46:28 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> Many users of debugfs copy the implementation of default_open()
> when they want to support a custom read/write function op. This
> leads to a proliferation of the default_open() implementation
> across the entire tree. Now that the common implementation has
> been consolidated into libfs we can replace all the users of this
> function with simple_open().
> 
>
> ...
>
> --- a/drivers/net/wireless/wl12xx/debugfs.c
> +++ b/drivers/net/wireless/wl12xx/debugfs.c
>

This broke.

I'm hitting quite a lot of build errors from this patch.  I'm not
confident that I will be able to compile-test every file that it
touches so I shall drop the patch.

Please fix it all up, compile-test *every* file, then resend.

If possible, against linux-next, please.  Quite a few things in this
area have been changed.
