Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2BQPQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:16:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:48502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2BQPQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:16:20 -0500
Message-ID: <1329491770.2293.278.camel@twins>
Subject: Re: [PATCH 2/2] rmap: anon_vma_prepare: Reduce code duplication by
 calling anon_vma_chain_link
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 16:16:10 +0100
In-Reply-To: <1329488908-7304-1-git-send-email-consul.kautuk@gmail.com>
References: <1329488908-7304-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 09:28 -0500, Kautuk Consul wrote:
> Reduce code duplication by calling anon_vma_chain_link from
> anon_vma_prepare.
> 
> Also move the anon_vmal_chain_link function to a more suitable location
> in the file.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
