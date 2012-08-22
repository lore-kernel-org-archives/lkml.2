Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab2HVTDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:03:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2HVTDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:03:16 -0400
Date: Wed, 22 Aug 2012 12:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Ben Hutchings <ben@decadent.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] mempolicy: Remove mempolicy sharing
Message-Id: <20120822120314.9fc30d47.akpm@linux-foundation.org>
In-Reply-To: <1345480594-27032-3-git-send-email-mgorman@suse.de>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de>
	<1345480594-27032-3-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012 17:36:31 +0100
Mel Gorman <mgorman@suse.de> wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Dave Jones' system call fuzz testing tool "trinity" triggered the following
> bug error with slab debugging enabled
> 
> ...
>
> Cc: <stable@vger.kernel.org>

The patch dosn't apply to 3.5 at all well.  I don't see much point in
retaining the stable tag so I think I'll remove it, and suggest that
you prepare a fresh patch for Greg and explain the situation?

