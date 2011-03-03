Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1CCCVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:21:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51279 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab1CCCVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:21:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 3 Mar 2011 11:15:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] Add alloc_page_vma_node
Message-Id: <20110303111533.3321f34f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299113128-11349-4-git-send-email-andi@firstfloor.org>
References: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
	<1299113128-11349-4-git-send-email-andi@firstfloor.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Mar 2011 16:45:23 -0800
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a alloc_page_vma_node that allows passing the "local" node in.
> Used in a followon patch.
> 
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

