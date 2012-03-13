Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2CMVWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:22:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49620 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2CMVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:22:47 -0400
Message-ID: <4F5FBAA3.3080508@pobox.com>
Date: Tue, 13 Mar 2012 17:22:43 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 13 (ata)
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au> <4F5FB6F0.6050300@xenotime.net>
In-Reply-To: <4F5FB6F0.6050300@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 05:06 PM, Randy Dunlap wrote:
> On 03/13/2012 02:41 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120309:
>
>
> on x86_64:
>
> ERROR: "ata_sas_port_async_resume" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_port_async_suspend" [drivers/scsi/libsas/libsas.ko] undefined!
>
>
> # CONFIG_SUSPEND is not set
> # CONFIG_PM_RUNTIME is not set
> # CONFIG_ACPI is not set

That sounds like the scsi tree (linux-scsi CC added).



