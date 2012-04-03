Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2DCGaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:30:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16267 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2DCGaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:30:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Apr 2012 23:30:01 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "kmpark@infradead.org" <kmpark@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 3 Apr 2012 08:29:54 +0200
Subject: Re: Linux 3.4-rc1
Thread-Topic: Linux 3.4-rc1
Thread-Index: Ac0RYy/hS/tIdnJmQuOxPqtVY75CAg==
Message-ID: <20120403.092954.1292069011296905405.hdoyu@nvidia.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com><CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com><CA+55aFw1ZG9R2MzgXmi0YE64t+xH95QnVuJB55sQ6xgDbnzkyQ@mail.gmail.com>
In-Reply-To: <CA+55aFw1ZG9R2MzgXmi0YE64t+xH95QnVuJB55sQ6xgDbnzkyQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.4-rc1
Date: Tue, 3 Apr 2012 05:57:26 +0200
Message-ID: 
 <CA+55aFw1ZG9R2MzgXmi0YE64t+xH95QnVuJB55sQ6xgDbnzkyQ@mail.gmail.com>

> On Mon, Apr 2, 2012 at 7:57 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> > On Sun, Apr 1, 2012 at 8:58 AM, Linus Torvalds
> >>
> >>  - DMA-mapping framework. The tree now has a few more acks from
> >> people, and it's largely in the same situation as HSI is: I'll
> >> probably pull, but I really wanted the users who are impacted to
> >> actually talk to me about it.
> >
> > Now Marek and Nvidia persons are used it for DMA mapping based IOMMU.
> >
> > Are there other person who help to merge it?
> > (+CC related persons).
> 
> I want the people who want it to contact me and talk about what they
> do with it. So far, I haven't seen anything.

Nvidia ARM SoC Tegra3 has IOMMU(SMMU), and most of its peripheral
devices can be clients of IOMMU. Their IOMMU'abiblity can be
configured. With DMA-mapping API, we wouldn't have to change any of
device driver code with\without IOMMU, but those 'dma_addr_t' could be
physical address or device virtual address trasparently.
