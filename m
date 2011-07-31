Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1GaLpC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 07:45:02 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58030 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1GaLo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 07:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <4E353F6B.1030501@parallels.com>
References: <20110720121612.28888.38970.stgit@localhost6>
	<alpine.DEB.2.00.1107201611010.3528@tiger>
	<20110720134342.GK5349@suse.de>
	<alpine.DEB.2.00.1107200854390.32737@router.home>
	<1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1107200950270.1472@router.home>
	<1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<4E353F6B.1030501@parallels.com>
Date: Sun, 31 Jul 2011 14:44:57 +0300
X-Google-Sender-Auth: cTpcODWNjazZx8Il1CVCX_BhKB0
Message-ID: <CAOJsxLEfKOEtv2DaM=8uMPPM5iP45A92fs=CE949TScHSkNgFA@mail.gmail.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
From: Pekka Enberg <penberg@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 2:41 PM, Konstantin Khlebnikov
<khlebnikov@parallels.com> wrote:
> It seems someone forgot this patch,

[snip]

>> [PATCH] slab: remove one NR_CPUS dependency
>>
>> Reduce high order allocations in do_tune_cpucache() for some setups.
>> (NR_CPUS=4096 ->  we need 64KB)

It's queued in slab/urgent branch and will be sent to Linus tonight.
