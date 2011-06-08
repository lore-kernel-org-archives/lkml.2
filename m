Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1FHNLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:11:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39081 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1FHNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:11:39 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <20110608130522.GC29089@parisc-linux.org>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com> <20110608130522.GC29089@parisc-linux.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 8 Jun 2011 16:11:16 +0300
Message-ID: <BANLkTin5JYt4=gru181N_BuvnHB7kUTUeQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] drivers/iommu/ relocations
To: Matthew Wilcox <matthew@wil.cx>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 4:05 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> You've missed at least parisc, ia64, alpha, sparc, powerpc and sh which
> have IOMMUs.

None of these seem to call register_iommu.

> Not that they necessarily all need to be moved across in
> one patchset, but saying "all iommu drivers" is clearly false.

I've moved only the existing IOMMU API users.
