Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2EBJHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:07:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42774 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab2EBJHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <1335909456-14020-1-git-send-email-thomas.abraham@linaro.org>
References: <1335909456-14020-1-git-send-email-thomas.abraham@linaro.org>
Date: Wed, 2 May 2012 10:07:45 +0100
Message-ID: <CAFbHwiSG6Z0aWuZvrydSjY07rgJpAuPx=9tzQDKc7UbaRTnY6A@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: make multiple instances of dw_mci_card_workqueue
From: Will Newton <will.newton@gmail.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        cjb@laptop.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jh80.chung@samsung.com, tgih.jun@samsung.com, dianders@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 10:57 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> The variable 'dw_mci_card_workqueue' is a global variable shared between
> multiple instances of the dw_mmc host controller. Due to this, data
> corruption has been noticed when multiple instances of dw_mmc controllers
> are actively reading/writing the media. Fix this by adding a instance
> of 'struct workqueue_struct' for each host instance and removing the
> global 'dw_mci_card_workqueue' instance.
>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/mmc/host/dw_mmc.c  |   14 ++++++--------
>  include/linux/mmc/dw_mmc.h |    1 +
>  2 files changed, 7 insertions(+), 8 deletions(-)

Looks good.

Acked-by: Will Newton <will.newton@imgtec.com>
