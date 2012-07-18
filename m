Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2GRVVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:21:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38763 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753514Ab2GRVVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:21:44 -0400
Message-ID: <1342646502.2215.2.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Joe Perches <joe@perches.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Wed, 18 Jul 2012 14:21:42 -0700
In-Reply-To: <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> This patch introduces acpi_pr_<level>(), where <level> is a message
> level such as err/warn/info, to support improved logging messages
> for ACPI, esp. in hotplug operations.  acpi_pr_<level>() appends
> "ACPI" prefix and ACPI object path to the messages.  This improves
> diagnostics in hotplug operations since it identifies an object that
> caused an issue in a log file.
> 
> acpi_pr_<level>() takes acpi_handle as an argument, which is passed
> to ACPI hotplug notify handlers from the ACPI CA.  Therefore, it is
> always available unlike other kernel objects, such as device.

Hi Toshi.

I'd be tempted to instead make the calls more like
other <subsystem>_<level> uses and rename these to
acpi_<level> and change the existing acpi_info to
another name.

Other than that, seems fine to me.

cheers, Joe

