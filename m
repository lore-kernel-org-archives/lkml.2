Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1CGXIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:08:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1CGXId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:08:33 -0500
Date: Mon, 7 Mar 2011 15:07:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, stable@kernel.org
Subject: Re: [PATCHv2] procfs: fix /proc/<pid>/maps heap check
Message-Id: <20110307150756.d50635f1.akpm@linux-foundation.org>
In-Reply-To: <1299244994-5284-1-git-send-email-aaro.koskinen@nokia.com>
References: <1299244994-5284-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Mar 2011 15:23:14 +0200
Aaro Koskinen <aaro.koskinen@nokia.com> wrote:

> The current code fails to print the "[heap]" marking if the heap is
> splitted into multiple mappings.
> 
> Fix the check so that the marking is displayed in all possible cases:
> 	1. vma matches exactly the heap
> 	2. the heap vma is merged e.g. with bss
> 	3. the heap vma is splitted e.g. due to locked pages
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> Cc: stable@kernel.org

Why do you believe this problem is serious enough to justify
backporting the fix into -stable?

