Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0I3EvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:51:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab0I3EvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:51:16 -0400
Date: Wed, 29 Sep 2010 21:52:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] fs: icache lock inode hash
Message-Id: <20100929215220.8b5f3910.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-4-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-4-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:35 +1000 Dave Chinner <david@fromorbit.com> wrote:

>  DEFINE_SPINLOCK(inode_lock);
>  DEFINE_SPINLOCK(sb_inode_list_lock);
> +DEFINE_SPINLOCK(inode_hash_lock);

I assume these all go away later on.  If not, they'll probably all land
in the same cacheline!

