Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2CSBeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 21:34:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56710 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab2CSBeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 21:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <1330592577-16546-8-git-send-email-ming.m.lin@intel.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
	<1330592577-16546-8-git-send-email-ming.m.lin@intel.com>
Date: Mon, 19 Mar 2012 09:34:08 +0800
X-Google-Sender-Auth: 4C3h7HxD-oESAvAsjxIe1VMvUZ0
Message-ID: <CAF1ivSbJi6rOYJ0wm7mPj2GtRG=UDHkm5TrbCHcSpup6H5EQjQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 7/8] PM / Runtime: Add can_power_off flag to subsys data
From: Lin Ming <ming.m.lin@intel.com>
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 5:02 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Parent device will check child's can_power_off flag to see if child device can
> be powered off.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  include/linux/pm.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index e4982ac..2e74531 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -465,6 +465,7 @@ struct pm_subsys_data {
>  #ifdef CONFIG_PM_GENERIC_DOMAINS
>        struct pm_domain_data *domain_data;
>  #endif
> +       bool can_power_off;

Hi Rafael,

I moved can_power_off flag to pm_subsys_daa.
SCSI/SATA will use it.

Is it OK to you?

Thanks,
Lin Ming

>  };
>
>  struct dev_pm_info {
> --
> 1.7.2.5
