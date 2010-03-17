Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab0CQQ1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:27:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0CQQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:27:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=PXAiVYGvx1ne90mu+vKhTxyW1FIM2VXmCs9E+pQ6sUpMomL1v96GEMNaKKekR/100
	nm2z9PNyUYNVnwmqvSdnA==
Date: Wed, 17 Mar 2010 16:26:41 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, lee.schermerhorn@hp.com, mel@csn.ul.ie,
       stable@kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/5] tmpfs: handle MPOL_LOCAL mount option properly
In-Reply-To: <20100316145022.4C4E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1003171619410.29003@sister.anvils>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org> <20100316143406.4C45.A69D9226@jp.fujitsu.com> <20100316145022.4C4E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, KOSAKI Motohiro wrote:

> commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
> shmem_sb_info) added mpol=local mount option. but its feature is
> broken since it was born. because such code always return 1 (i.e.
> mount failure).
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Ravikiran Thirumalai <kiran@scalex86.org>

Thank you both for finding and fixing these mpol embarrassments.

But if this "mpol=local" feature was never documented (not even in the
commit log), has been broken since birth 20 months ago, and nobody has
noticed: wouldn't it be better to save a little bloat and just rip it out?

Hugh
