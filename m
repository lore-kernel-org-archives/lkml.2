Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2GIXj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:39:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab2GIXj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:39:26 -0400
Date: Mon, 9 Jul 2012 16:39:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] shmem/tmpfs: three late patches
Message-Id: <20120709163925.4b71bdc2.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils>
References: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 15:35:26 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> Here's three little shmem/tmpfs patches against v3.5-rc6.
> Either the first should go in before v3.5 final, or it should not go
> in at all.  The second and third are independent of it: I'd like them
> in v3.5, but don't have a clinching argument: see what you think.

Thanks, I queued all three for 3.5.
