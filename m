Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1GXQsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 12:48:24 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:59219 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1GXQsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 12:48:17 -0400
X-SpamScore: -8
X-BigFish: VS-8(zz9371M98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "List linux-kernel@vger.kernel.org Mailing" 
	<linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2/5] hugetlb: add phys addr to struct huge_bootmem_page
Thread-Topic: [PATCH 2/5] hugetlb: add phys addr to struct huge_bootmem_page
Thread-Index: AQHMSiF66feBPV+Jc0qX6tn5JbQ9bw==
Date: Sun, 24 Jul 2011 16:48:13 +0000
Message-ID: <CAOZdJXWUydw_9W-7g_TydpxY22Pq1ntba_HRLZQK3opvHnwjTQ@mail.gmail.com>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
	<13092909493748-git-send-email-beckyb@kernel.crashing.org>
	<13092910103675-git-send-email-beckyb@kernel.crashing.org>
	<1309297166.32158.461.camel@pasglop>
	<786B027A-4EC8-4175-A18D-9DA57E9549D6@kernel.crashing.org>
In-Reply-To: <786B027A-4EC8-4175-A18D-9DA57E9549D6@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <2DB1517EE025A14687AEB4F8216926F3@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 1:50 PM, Becky Bruce <beckyb@kernel.crashing.org> wrote:

> Because there was no bootmem allocation in the normal case - the non-highmem
> version stores data structure in the huge page itself.  This is perfectly fine as long
> as you have a mapping.  Since this isn't true for HIGHMEM pages, I allocate
> bootmem to store the early data structure that stores information about the
> hugepage (this happens in arch-specific code in alloc_bootmem_huge_page).

I would put this text in a comment in the code.

-- 
Timur Tabi
Linux kernel developer at Freescale
