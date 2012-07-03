Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2GCQOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:14:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30214 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2GCQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:14:33 -0400
X-IronPort-AV: E=Sophos;i="4.77,516,1336363200"; 
   d="scan'208";a="200920643"
Message-ID: <4FF31A66.30904@citrix.com>
Date: Tue, 3 Jul 2012 17:14:30 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/4] xen/perf: Define .glob for the different
 hypercalls.
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com> <1341330038-21686-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1341330038-21686-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/12 16:40, Konrad Rzeszutek Wilk wrote:
> This allows us in perf to have this:
> 
>  99.67%  [kernel]             [k] xen_hypercall_sched_op
>   0.11%  [kernel]             [k] xen_hypercall_xen_version
> 
> instead of the borring ever-encompassing:
> 
>  99.13%  [kernel]              [k] hypercall_page
...
> +ENTRY(xen_hypercall_other)
> +	.skip 2272

I can't offhand think of way of doing this, but is there a less fragile
way to do this?

.skip PAGE_SIZE - N * 32 or something ?

David
