Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1CGH7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:59:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53377 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1CGH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:59:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCHv2] procfs: fix /proc/<pid>/maps heap check
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@kernel.org
In-Reply-To: <1299244994-5284-1-git-send-email-aaro.koskinen@nokia.com>
References: <1299244994-5284-1-git-send-email-aaro.koskinen@nokia.com>
Message-Id: <20110307165145.89FE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 16:59:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> ---
> 
> v2: Rewrote the changelog.

Looks good.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



