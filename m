Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2GJLaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:30:10 -0400
Received: from plane.gmane.org ([80.91.229.3]:37882 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab2GJLaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:30:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: IgorMammedov <imammedo@redhat.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
Date: Tue, 10 Jul 2012 11:29:12 +0000 (UTC)
Message-ID: <loom.20120710T132300-88@post.gmane.org>
References: <16070.2632544146$1340981518@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 209.132.186.34 (Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20100101 Firefox/13.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 <y <at> domain.invalid> writes:

> 
> From: Toshi Kani <toshi.kani <at> hp.com>
> 
> Added CPU hot-remove support through an ACPI eject notification.
> It calls acpi_bus_hot_remove_device(), which shares the same code
> path with the sysfs eject operation.  acpi_os_hotplug_execute()
> serializes hot-remove operations between ACPI hot-remove and sysfs
> eject requests.
> 
> Signed-off-by: Toshi Kani <toshi.kani <at> hp.com>
> 
> ---
> This patch applies on top of the patchset below.
> 
> [PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
> http://marc.info/?l=linux-acpi&m=134074381322973&w=2
> 
Hi Toshi,

Tested patches on RHEL6.3, ejected cpu is removed from sysfs and corresponding
_EJxx method is called  as expected upon receiving notify with eject request.

Tested-by: IgorMammedov <imammedo@redhat.com>

