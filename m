Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2HUPh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:37:29 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:11898 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab2HUPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:37:26 -0400
Date: Tue, 21 Aug 2012 15:37:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] mempolicy: fix a memory corruption by refcount
 imbalance in alloc_pages_vma()
In-Reply-To: <20120821072611.GC1657@suse.de>
Message-ID: <0000013949d4c42b-231ae8aa-8ef8-47a4-b658-6c3fb5961347-000000@email.amazonses.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-6-git-send-email-mgorman@suse.de> <000001394596bd69-2c16d7fb-71b5-4009-95cc-7068103b2bfd-000000@email.amazonses.com> <20120821072611.GC1657@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Mel Gorman wrote:

> mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()

Reviewed-by: Christoph Lameter <cl@linux.com>
