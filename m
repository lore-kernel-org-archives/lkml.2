Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2ARJK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:10:29 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:50358 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399Ab2ARJK0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:10:26 -0500
MIME-Version: 1.0
In-Reply-To: <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-1-git-send-email-rmorell@nvidia.com> <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 18 Jan 2012 14:40:04 +0530
Message-ID: <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
To: Robert Morell <rmorell@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> issue, and not really an interface".  The dma-buf infrastructure is
> explicitly intended as an interface between modules/drivers, so it
> should use EXPORT_SYMBOL instead.

+ Konrad, Arnd, Mauro: there were strong objections on using
EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
suggest we first arrive at a consensus before merging this patch.

Best regards,
~Sumit.
<snip>
