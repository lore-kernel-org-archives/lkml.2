Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0GWDih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:38:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:41809 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab0GWDif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:38:35 -0400
Message-ID: <4C490EB0.2030007@windriver.com>
Date: Thu, 22 Jul 2010 22:38:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the kgdb tree with Linus' tree
References: <20100723122646.a788fc86.sfr@canb.auug.org.au>
In-Reply-To: <20100723122646.a788fc86.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2010 03:38:26.0452 (UTC) FILETIME=[82571D40:01CB2A18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 09:26 PM, Stephen Rothwell wrote:
> Hi Jason,
>
> Today's linux-next merge of the kgdb tree got a conflict in
> kernel/debug/kdb/kdb_main.c between commit
> edd63cb6b91024332d6983fc51058ac1ef0c081e ("sysrq,kdb: Use __handle_sysrq
> () for kdb's sysrq function") from Linus' tree and commit
> 93c47fada46e034941106fb34b76a00a87108fc5 ("kdb: Restore previous sysrq
> state") from the kgdb tree.
>
> These are two fixes for the same problem.  I effectively reverted the one
> from the kgdb tree.
>   

This already fixed.  The problem was caused by the for_linus pull branch
being out of sync with kgdb-next.

Thanks,
Jason.
