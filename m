Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1GSIpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:45:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56047 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1GSIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1311059367.15392.299.camel@sli10-conroe>
References: <1311059367.15392.299.camel@sli10-conroe>
Date: Tue, 19 Jul 2011 17:45:16 +0900
Message-ID: <CAEwNFnB6HKJ3j9cWzyb2e3BS2BQrE66F6eT02C4cozRC9YQ7kw@mail.gmail.com>
Subject: Re: [PATCH]vmscan: fix a livelock in kswapd
From: Minchan Kim <minchan.kim@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 4:09 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> I'm running a workload which triggers a lot of swap in a machine with 4 nodes.
> After I kill the workload, I found a kswapd livelock. Sometimes kswapd3 or
> kswapd2 are keeping running and I can't access filesystem, but most memory is
> free. This looks like a regression since commit 08951e545918c159.

Could you tell me what is 08951e545918c159?
You mean [ebd64e21ec5a,
mm-vmscan-only-read-new_classzone_idx-from-pgdat-when-reclaiming-successfully]
?


-- 
Kind regards,
Minchan Kim
