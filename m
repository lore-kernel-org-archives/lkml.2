Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1AYGTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:19:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab1AYGTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:19:53 -0500
Date: Mon, 24 Jan 2011 22:19:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Jan Kara <jack@ucw.cz>
Subject: Re: [RFC][PATCH] radix_tree: radix_tree_gang_lookup_tag_slot may
 not return forever.
Message-Id: <20110124221916.041ea5d7.akpm@linux-foundation.org>
In-Reply-To: <20110125135345.ca4bfd79.toshi.okajima@jp.fujitsu.com>
References: <20110121153431.acd113d8.toshi.okajima@jp.fujitsu.com>
	<20110121153154.1ca74dd2.akpm@linux-foundation.org>
	<20110125135345.ca4bfd79.toshi.okajima@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 13:53:45 +0900 Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> > It should be fairly simple to reproduce this hang with the userspace
> > test harness (http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz) and to
> > then demonstrate that the fix fixes it.
> > 
> > If you have time, could you please do that and then send the rtth
> > updates to me?
> > 
> I add regression2_test for this bug into your testset (rtth.tar.gz).
> This is originated from regression1_test.

Thanks.  I applied your
radix_tree-radix_tree_gang_lookup_tag_slot-may-not-return-forever.patch
to rtth's radix-tree.c (it was needed!) and refreshed
http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz
