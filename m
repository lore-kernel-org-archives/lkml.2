Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab1GOG6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:58:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44212 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964770Ab1GOG6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:58:38 -0400
Message-ID: <4E1FE51B.70009@pobox.com>
Date: Fri, 15 Jul 2011 02:58:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: Len Brown <lenb@kernel.org>, kernel-hardening@lists.openwall.com,
        Shaohua Li <shaohua.li@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] acpi: constify ops structs
References: <20110625170752.GA10458@albatros> <20110715063526.GB3166@albatros>
In-Reply-To: <20110715063526.GB3166@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 02:35 AM, Vasiliy Kulikov wrote:
> Hi Len,
>
> On Sat, Jun 25, 2011 at 21:07 +0400, Vasiliy Kulikov wrote:
>> Structs battery_file, acpi_dock_ops, file_operations,
>> thermal_cooling_device_ops, thermal_zone_device_ops, kernel_param_ops
>> are not changed in runtime.  It is safe to make them const.
>> register_hotplug_dock_device() was altered to take const "ops" argument
>> to respect acpi_dock_ops' const notion.
>>
>> Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


