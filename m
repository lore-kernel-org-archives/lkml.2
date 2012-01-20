Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2ATSFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:05:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6051 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2ATSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:05:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Jan 2012 10:04:57 -0800
Date: Fri, 20 Jan 2012 10:04:57 -0800
From: Robert Morell <rmorell@nvidia.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20120120180457.GE29824@morell.nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
 <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
 <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 01:10:04AM -0800, Semwal, Sumit wrote:
> On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
> > EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> > issue, and not really an interface".  The dma-buf infrastructure is
> > explicitly intended as an interface between modules/drivers, so it
> > should use EXPORT_SYMBOL instead.
> 
> + Konrad, Arnd, Mauro: there were strong objections on using
> EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
> suggest we first arrive at a consensus before merging this patch.

This discussion seems to have stagnated; how do we move forward here?

Sumit, as the primary author and new maintainer (congrats!) of the
dma-buf infrastructure, it seems like it's really your call how to
proceed.  I'd still like to see this be something that we can use from
the nvidia and fglrx drivers for Xorg buffer sharing, as I and Dave have
argued in this thread.  It really seems to me that this change on a
technical level won't have any adverse effect on the scenarios where it
can be used today, but it will allow it to be used more widely, which
will prevent duplication and fragmentation in the future and be greatly
appreciated by users of hardware such as Optimus.

Let me know if you have any questions.

Thanks,
Robert
