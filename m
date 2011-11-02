Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1KBDZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 23:25:55 -0400
Received: from ozlabs.org ([203.10.76.45]:34294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab1KBDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 23:25:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] cpumask: update the Note of setup_node_to_cpumask_map
In-Reply-To: <1320133056-25752-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1320133056-25752-1-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 02 Nov 2011 11:27:37 +1030
Message-ID: <877h3juyri.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 15:37:36 +0800, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> node_to_cpumask() had been replaced by cpumask_of_node(), and wholly
> removed since commit 29c337a0.
> 
> So update the Note of setup_node_to_cpumask_map().
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Andrew, can you take this?

Thanks,
Rusty.
