Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0INVXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 17:23:43 -0400
Received: from khc.piap.pl ([195.187.100.11]:50619 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab0INVXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 17:23:42 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce devices
References: <20100901085738.GJ8142@n2100.arm.linux.org.uk>
	<20100902114937X.fujita.tomonori@lab.ntt.co.jp>
	<20100905112513.GB558@n2100.arm.linux.org.uk>
	<20100906083105X.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 14 Sep 2010 23:23:38 +0200
In-Reply-To: <20100906083105X.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Mon, 6 Sep 2010 08:32:45 +0900")
Message-ID: <m34odsrpd1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

>> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> > Subject: [PATCH] arm: fix arm: fix pci_set_consistent_dma_mask for dmabounce devices
>> > 
>> > This fixes the regression caused by the commit
>> > 6fee48cd330c68332f9712bc968d934a1a84a32a.


>> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
>
> Should I send this to Linus? Or Can I assume that someone in ARM camp
> will do?

It would be nice if you do. TIA.
-- 
Krzysztof Halasa
