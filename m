Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2GDIna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:43:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4528 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2GDIn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:43:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,521,1336320000"; 
   d="scan'208";a="5327244"
Message-ID: <4FF40242.8060203@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 16:43:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Mel Gorman <mel@csn.ul.ie>, Chris Metcalf <cmetcalf@tilera.com>,
        Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andi Kleen <andi@firstfloor.org>, Julia Lawall <julia@diku.dk>,
        David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rik van Riel <riel@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/3 V1] mm: add new migrate type and online_movable
 for hotplug
References: <1341386778-8002-1-git-send-email-laijs@cn.fujitsu.com> <CAEwNFnAHVHKtS2o=gEBSMGq8X18T_xFsK6CwxdfYtz1ne6KCQw@mail.gmail.com> <4FF3FD7F.5020706@cn.fujitsu.com>
In-Reply-To: <4FF3FD7F.5020706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 16:43:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 16:43:30,
	Serialize complete at 2012/07/04 16:43:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 04:23 PM, Lai Jiangshan wrote:
> On 07/04/2012 03:35 PM, Minchan Kim wrote:
>> Hello,
>>
>> I am not sure when I can review this series by urgent other works.
>> At a glance, it seems to attract me.

Patches are resent with updated cover-letter and correct cc list.

Thank you very much.
Lai


>> But unfortunately, when I read description in cover-letter, I can't
>> find "What's the problem?".
>> If you provide that, it could help too many your Ccing people who can
>> judge  "whether I dive into code or not"
> 
> This patchset adds a stable-movable-migrate-type for memory-management,
> It is used for anti-fragmentation(hugepage, big-order alloction...) and
> hot-removal-of-memory(virtualization, power-conserve, move memory between systems).
> it likes ZONE_MOVABLE, but it is more elastic.
> 
> Beside it, it fixes some code of CMA.
> 
> Thanks,
> Lai
> 
