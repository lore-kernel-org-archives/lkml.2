Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab1FFPRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:17:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44394 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1FFPR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:17:29 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <201106061110.30601.arnd@arndb.de>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <201106031753.16095.arnd@arndb.de> <BANLkTim2pDu25ZudZ7ZzOwka0V1sYEhDKw@mail.gmail.com>
 <201106061110.30601.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 6 Jun 2011 18:17:07 +0300
Message-ID: <BANLkTin9oDn=PFSJ6MY=+MY9RxnmO4G6HA@mail.gmail.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        laurent.pinchart@ideasonboard.com, Hiroshi.DOYU@nokia.com,
        davidb@codeaurora.org, Joerg.Roedel@amd.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, anil.s.keshavamurthy@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> I'd still prefer us to take small steps here, and not gate the omap
>> iommu cleanups with Marek's generic dma_map_ops work though. Let's go
>> forward and migrate omap's iommu to the generic iommu API, so new code
>> will be able to use it (e.g. the long coming virtio-based IPC/AMP
>> framework).
>
> Yes, of course. That's what I meant. Moving over omap to the IOMMU API
> is required anyway, so there is no point delaying that.

Ok, great !
