Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2BXEGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:06:16 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60535 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2BXEGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:06:14 -0500
Message-ID: <4F470CB3.2010800@garzik.org>
Date: Thu, 23 Feb 2012 23:06:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: linux-next: build warning after merge of the libata tree
References: <20120213162740.9e3cb47a39da19ed89edea49@canb.auug.org.au> <20120224140814.c134151d30e3f32b36360d5d@canb.auug.org.au>
In-Reply-To: <20120224140814.c134151d30e3f32b36360d5d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 10:08 PM, Stephen Rothwell wrote:
> Hi Jeff, Matthew,
>
> On Mon, 13 Feb 2012 16:27:40 +1100 Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>
>> After merging the libata tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced this warning:
>>
>> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not used [-Wunused-function]
>> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but not used [-Wunused-function]
>>
>> Introduced by commits 75d22cd567ca ("libata: Bind the Linux device tree
>> to the ACPI device tree") and c9df614ade0e ("libata: Add links between
>> removable devices and docks").
>
> Ping?

A build fix and oops fix were both just pushed out.

	Jeff


