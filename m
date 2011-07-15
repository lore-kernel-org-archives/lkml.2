Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab1GOGfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:35:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44793 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778Ab1GOGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:35:41 -0400
Date: Fri, 15 Jul 2011 10:35:26 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Len Brown <lenb@kernel.org>
Cc: kernel-hardening@lists.openwall.com, Shaohua Li <shaohua.li@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] acpi: constify ops structs
Message-ID: <20110715063526.GB3166@albatros>
References: <20110625170752.GA10458@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110625170752.GA10458@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Sat, Jun 25, 2011 at 21:07 +0400, Vasiliy Kulikov wrote:
> Structs battery_file, acpi_dock_ops, file_operations,
> thermal_cooling_device_ops, thermal_zone_device_ops, kernel_param_ops
> are not changed in runtime.  It is safe to make them const.
> register_hotplug_dock_device() was altered to take const "ops" argument
> to respect acpi_dock_ops' const notion.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---

Any problems with the patch?

>  Len, I think it can be applied as a single patch to acpi tree as the
>  only non-acpi thing is acpi_dock_ops in ata/ and pci/, which is really
>  trivial.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
