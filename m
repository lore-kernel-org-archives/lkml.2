Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab2J3Nih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:38:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55732 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933708Ab2J3Nif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:38:35 -0400
MIME-Version: 1.0
In-Reply-To: <1351600332-29443-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1351600332-29443-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 30 Oct 2012 19:08:34 +0530
X-Google-Sender-Auth: Ra-qGMrlx4Gb8i043ZayJCIvxQY
Message-ID: <CAOh2x=mexJCaVUP5QshLKXb47OWNv40k55coADQcrYCX1gtRYA@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: add recently created files to dw_dmac section
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 6:02 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The DesignWare DMAC driver is moved to an own directory. The patch updates
> MAINTAINERS file accordingly.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  MAINTAINERS |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

I don't agree with the order of patches. Why create *pci.c file first
and then move it
to some other folder.

I would have done following:
PATCH 1/2: Merge of your 2/3 and 3/3
PATCH 2/2: Your 1/3

--
viresh
