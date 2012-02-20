Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2BTCux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:50:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51357 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2BTCuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:50:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Feb 2012 11:49:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rmap: anon_vma_prepare: Reduce code duplication by
 calling anon_vma_chain_link
Message-Id: <20120220114928.8507095c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1329488908-7304-1-git-send-email-consul.kautuk@gmail.com>
References: <1329488908-7304-1-git-send-email-consul.kautuk@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 09:28:28 -0500
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> Reduce code duplication by calling anon_vma_chain_link from
> anon_vma_prepare.
> 
> Also move the anon_vmal_chain_link function to a more suitable location
> in the file.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Reviewed-by: KAMEZWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


