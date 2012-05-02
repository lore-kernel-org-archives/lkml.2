Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2EBJK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:10:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34784 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab2EBJKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <1335935266-25289-3-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-3-git-send-email-thomas.abraham@linaro.org>
Date: Wed, 2 May 2012 10:10:25 +0100
Message-ID: <CAFbHwiTRzGJgxxMAkqDDM-fPxgGe1bC3yKWCM+bNp3-i7WWcZw@mail.gmail.com>
Subject: Re: [PATCH 2/7] mmc: dw_mmc: add quirk to indicate missing write
 protect line
From: Will Newton <will.newton@gmail.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 6:07 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> If the write protect pad of the controller is not connected to the write
> protect pin of the slot, the driver should be notified of this condition
> so that incorrect check for write protection by reading the WRTORT
> register can avoided. The get_ro platform callback can be used for in
> such cases, but with device tree support enabled, such platform callbacks
> cannot be supported.
>
> Add a new quirk for notifying the driver about the missing write protect
> line so the driver can assume that the card write protection is disabled.
>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/mmc/host/dw_mmc.c  |    4 +++-
>  include/linux/mmc/dw_mmc.h |    3 ++-
>  2 files changed, 5 insertions(+), 2 deletions(-)

Acked-by: Will Newton <will.newton@imgtec.com>
