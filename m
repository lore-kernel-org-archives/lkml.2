Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1FHTfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:35:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58685 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab1FHTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:35:43 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <20110608174734.GF23047@sequoia.sous-sol.org>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <1307522062-19273-5-git-send-email-ohad@wizery.com> <20110608174734.GF23047@sequoia.sous-sol.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 8 Jun 2011 22:35:22 +0300
Message-ID: <BANLkTinu4hCk3PqXL6dA3JUqCX-BPwg3wg@mail.gmail.com>
Subject: Re: [PATCH 4/4] x86: intel-iommu: move to drivers/iommu/
To: Chris Wright <chrisw@sous-sol.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <Joerg.Roedel@amd.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-omap@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 8:47 PM, Chris Wright <chrisw@sous-sol.org> wrote:
> You may want to further restrict to x86 and ia64
> And I think you'll need to fixup arch/ia64/Kconfig
>
> BTW, I think EXPERIMENTAL can be dropped by now.

Sounds all good, thanks a lot !
