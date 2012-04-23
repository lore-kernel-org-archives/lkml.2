Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2DWVzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:55:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2DWVzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:55:47 -0400
Date: Mon, 23 Apr 2012 14:55:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsprintf: Fix %ps on non symbols when using
 kallsyms
Message-Id: <20120423145545.e7c41906.akpm@linux-foundation.org>
In-Reply-To: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 14:45:24 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> Using %ps in a printk format will sometimes fail silently and
> print the empty string if the address passed in does not match a
> symbol that kallsyms knows about.

Oh.  The stupid mails came in reverse order.
