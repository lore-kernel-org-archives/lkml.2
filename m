Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2CLHqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:46:19 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60342 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2CLHqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:46:11 -0400
Date: Mon, 12 Mar 2012 16:52:37 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: MMU: Split the main body of
 rmap_write_protect() off from others
Message-Id: <20120312165237.8edabf54.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120312163916.66bfd660.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193122.f21dc089.yoshikawa.takuya@oss.ntt.co.jp>
	<20120312163916.66bfd660.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

> Something may change here: when level > PT_PAGE_TABLE_LEVEL, this loop
> does not handle lower level mappings after dropping large-ptes.
> 
> This may be incorrect.

On second thoughts, this seems to be no problem.
I was just confused.

Thanks,
	Takuya
