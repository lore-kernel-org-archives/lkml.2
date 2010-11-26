Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0KZWFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:05:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33258 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0KZWFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:05:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCH] pm: fix comments to match runtime callback code
Date: Fri, 26 Nov 2010 23:04:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1290181732-9124-1-git-send-email-aaro.koskinen@nokia.com>
In-Reply-To: <1290181732-9124-1-git-send-email-aaro.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262304.15787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Aaro Koskinen wrote:
> Commit 05aa55dddb9ee4045c320661068bea78dad6a6e5 changed routines to
> succeed if the driver handler is not defined. Comments were not updated.

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> ---
>  drivers/base/power/generic_ops.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
> index 81f2c84..3d2c350 100644
> --- a/drivers/base/power/generic_ops.c
> +++ b/drivers/base/power/generic_ops.c
> @@ -39,7 +39,7 @@ EXPORT_SYMBOL_GPL(pm_generic_runtime_idle);
>   *
>   * If PM operations are defined for the @dev's driver and they include
>   * ->runtime_suspend(), execute it and return its error code.  Otherwise,
> - * return -EINVAL.
> + * return 0.
>   */
>  int pm_generic_runtime_suspend(struct device *dev)
>  {
> @@ -58,7 +58,7 @@ EXPORT_SYMBOL_GPL(pm_generic_runtime_suspend);
>   *
>   * If PM operations are defined for the @dev's driver and they include
>   * ->runtime_resume(), execute it and return its error code.  Otherwise,
> - * return -EINVAL.
> + * return 0.
>   */
>  int pm_generic_runtime_resume(struct device *dev)
>  {
> 

