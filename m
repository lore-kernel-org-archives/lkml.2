Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966426Ab0GSSls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:41:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40331 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966390Ab0GSSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:41:35 -0400
Date: Mon, 19 Jul 2010 19:40:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: Tim HRM <zt.tmzt@gmail.com>, Zach Pfeffer <zpfeffer@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
Message-ID: <20100719184002.GA21608@n2100.arm.linux.org.uk>
References: <20100713150311B.fujita.tomonori@lab.ntt.co.jp> <20100713121420.GB4263@codeaurora.org> <20100714104353B.fujita.tomonori@lab.ntt.co.jp> <20100714201149.GA14008@codeaurora.org> <20100714220536.GE18138@n2100.arm.linux.org.uk> <20100715012958.GB2239@codeaurora.org> <20100715085535.GC26212@n2100.arm.linux.org.uk> <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com> <20100716075856.GC16124@n2100.arm.linux.org.uk> <4C449183.20000@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C449183.20000@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:55:15AM -0700, Michael Bohan wrote:
>
> On 7/16/2010 12:58 AM, Russell King - ARM Linux wrote:
>
>> As the patch has been out for RFC since early April on the linux-arm-kernel
>> mailing list (Subject: [RFC] Prohibit ioremap() on kernel managed RAM),
>> and no comments have come back from Qualcomm folk.
>
> Would it be unreasonable to allow a map request to succeed if the  
> requested attributes matched that of the preexisting mapping?

What would be the point of creating such a mapping?
