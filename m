Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1FJQY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:24:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50947 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1FJQY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:24:26 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <8yamxhsklhd.fsf@huya.qualcomm.com>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <1307522062-19273-3-git-send-email-ohad@wizery.com> <8yamxhsklhd.fsf@huya.qualcomm.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 10 Jun 2011 19:24:05 +0300
Message-ID: <BANLkTi=owGc5JU1eF5wZmgiC0GbTCury8w@mail.gmail.com>
Subject: Re: [PATCH 2/4] msm: iommu: move to drivers/iommu/
To: David Brown <davidb@codeaurora.org>
Cc: stepanm@codeaurora.org, Joerg Roedel <Joerg.Roedel@amd.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 1:27 AM, David Brown <davidb@codeaurora.org> wrote:
> Moving the driver is good.  I'm wondering what we should do with
> iommu_dev.c, though.  Wouldn't it make sense to move this file as well?

Yeah, it does make sense. I'll move that one too, thanks.
