Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2C3Ftc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:49:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43501 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2C3Ft0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:49:26 -0400
Message-ID: <4F754963.4080104@kernel.org>
Date: Fri, 30 Mar 2012 01:49:23 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] PM / Runtime: Add may_power_off flag to subsys
 data
References: <1333001380-6050-1-git-send-email-ming.m.lin@intel.com> <1333001380-6050-4-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1333001380-6050-4-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why?

-Len

On 03/29/2012 02:09 AM, Lin Ming wrote:

> Parent device will check child's may_power_off flag to see if child device can
> be powered off.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  include/linux/pm.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index e4982ac..c9953b4 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -465,6 +465,7 @@ struct pm_subsys_data {
>  #ifdef CONFIG_PM_GENERIC_DOMAINS
>  	struct pm_domain_data *domain_data;
>  #endif
> +	bool may_power_off;
>  };
>  
>  struct dev_pm_info {


