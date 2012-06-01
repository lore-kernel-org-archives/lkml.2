Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966014Ab2FAXM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:12:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50713 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965953Ab2FAXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:12:27 -0400
Message-ID: <4FC94C57.8000604@kernel.org>
Date: Fri, 01 Jun 2012 19:12:23 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH -v2] ACPI, PM, Specify lowest allowed state for device
 sleep state
References: <1337305544-10393-1-git-send-email-ying.huang@intel.com>
In-Reply-To: <1337305544-10393-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 09:45 PM, Huang Ying wrote:

> Lower device sleep state can save more power, but has more exit
> latency too.  Sometimes, to satisfy some power QoS and other
> requirement, we need to constrain the lowest device sleep state.
> 
> In this patch, a parameter to specify lowest allowed state for
> acpi_pm_device_sleep_state is added.  So that the caller can enforce
> the constraint via the parameter.
> 
> This is needed by PCIe D3cold support, where the lowest power state
> allowed may be D3_HOT instead of default D3_COLD.
> 
> Changelog:
> 
> v2:
> - Minor change per Rafeal's comments
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/acpi/sleep.c       |   24 +++++++++++++++++++-----
>  drivers/pci/pci-acpi.c     |    3 ++-
>  drivers/pnp/pnpacpi/core.c |    4 ++--
>  include/acpi/acpi_bus.h    |    6 +++---
>  4 files changed, 26 insertions(+), 11 deletions(-)



Applied.

thanks,
Len Brown, Intel Open Source Technology Center

