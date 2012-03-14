Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab2CNAgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:36:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48334 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab2CNAgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F5FBAA3.3080508@pobox.com>
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
	<4F5FB6F0.6050300@xenotime.net>
	<4F5FBAA3.3080508@pobox.com>
Date: Tue, 13 Mar 2012 17:36:50 -0700
Message-ID: <CAA9_cmf=WzQkDpahv73yBbe1NHTrxV7=K1PToH80K9EY_rzUgg@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 13 (ata)
From: Dan Williams <dan.j.williams@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:22 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 03/13/2012 05:06 PM, Randy Dunlap wrote:
>>
>> On 03/13/2012 02:41 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120309:
>>
>>
>>
>> on x86_64:
>>
>> ERROR: "ata_sas_port_async_resume" [drivers/scsi/libsas/libsas.ko]
>> undefined!
>> ERROR: "ata_sas_port_async_suspend" [drivers/scsi/libsas/libsas.ko]
>> undefined!
>>
>>
>> # CONFIG_SUSPEND is not set
>> # CONFIG_PM_RUNTIME is not set
>> # CONFIG_ACPI is not set
>
>
> That sounds like the scsi tree (linux-scsi CC added).

That's on me, new suspend/resume support for libsas.  Looks like I
need stubs for the CONFIG_PM=n case.  Revised patches coming up.

--
Dan
