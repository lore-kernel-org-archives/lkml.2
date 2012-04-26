Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab2DZSPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab2DZSPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:15:50 -0400
Message-ID: <4F9990D9.10300@redhat.com>
Date: Thu, 26 Apr 2012 14:15:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Motohiro Kosaki <mkosaki@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm V3] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
References: <4F998FDE.5020104@redhat.com>
In-Reply-To: <4F998FDE.5020104@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 02:11 PM, Larry Woodman wrote:

> This patch changes do_migrate_pages() to only preserve the relative
> layout inside the
> program if the number of NUMA nodes in the source and destination mask
> are the
> same. If the number is different, we do a much more efficient migration
> by not touching
> memory that is in an allowed node.
>
> This preserves the old behaviour for programs that want it, while
> allowing a userspace
> NUMA placement tool to use the new, faster migration. This improves
> performance in
> our tests by up to a factor of 7.

> Signed-off-by: Larry Woodman<lwoodman@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

