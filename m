Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1LASsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:48:15 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:13864 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1LASsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:48:12 -0500
Message-ID: <4ED7CBEA.6060005@tilera.com>
Date: Thu, 1 Dec 2011 13:48:10 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lib/devres.c: allow specifying NO_IOPORT while using
 PCI
References: <cover.1322592494.git.mst@redhat.com> <201111301404.41544.arnd@arndb.de> <20111130143122.GC21413@redhat.com> <201111301549.57430.arnd@arndb.de> <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com> <20111201184442.GA13173@google.com>
In-Reply-To: <20111201184442.GA13173@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/2011 1:44 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Dec 01, 2011 at 12:59:19PM -0500, Chris Metcalf wrote:
>> The tile architecture does not support IOPORT, but it does support
>> PCI and IOMEM.  We were not specifying NO_IOPORT, though, because it
>> was causing a couple of functions (pcim_iomap_regions and pcim_iomap_table)
>> that are needed to not get provided.  Moving the #ifdef fixes this
>> so that those functions and some related ones are now always provided
>> if CONFIG_PCI is true.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>   Acked-by: Tejun Heo <tj@kernel.org>
>
> Please feel free to route the change through tile.  If not, Andrew,
> can you please pick this up?

Thanks.  I'll plan to push this to Linus through the tile tree with your
Acked-by.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

