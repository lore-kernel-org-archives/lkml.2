Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2HNU6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab2HNU5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:57:14 -0400
Message-ID: <502ABB9B.90108@redhat.com>
Date: Tue, 14 Aug 2012 16:56:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives
 to balloon pages
References: <cover.1344619987.git.aquini@redhat.com> <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com> <20120813084123.GF14081@redhat.com> <20120814182244.GB13338@t510.redhat.com> <20120814195139.GA28870@redhat.com> <20120814195916.GC28870@redhat.com> <20120814200830.GD22133@t510.redhat.com> <20120814202401.GB28990@redhat.com> <20120814202949.GF22133@t510.redhat.com> <20120814204906.GD28990@redhat.com> <20120814205426.GA29162@redhat.com>
In-Reply-To: <20120814205426.GA29162@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 04:54 PM, Michael S. Tsirkin wrote:

> To clarify, the global state that this patch adds, is ugly
> even if we didn't support multiple balloons yet.
> So I don't think I can accept such a patch.
> Rusty has a final word here, maybe he thinks differently.

Before deciding that "does not support multiple balloon drivers
at once" is an issue, is there any use case at all for having
multiple balloon drivers active at a time?

I do not see any.

-- 
All rights reversed
