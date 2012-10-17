Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2JQKhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:37:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57794 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab2JQKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:37:00 -0400
MIME-Version: 1.0
In-Reply-To: <1350469879-16018-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1350469879-16018-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 17 Oct 2012 16:06:59 +0530
X-Google-Sender-Auth: eIgYmh2xu8xSZIlGLZyjs0EmzGE
Message-ID: <CAOh2x==huWpT5fDL8evBn2Lm1czxY5nYOePJK0mpfUp1hBYcyA@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] dw_dmac: don't call platform_get_drvdata twice
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 4:01 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
