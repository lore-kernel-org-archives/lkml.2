Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0LAWIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 17:08:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0LAWIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 17:08:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 12/13] ACPI / PM: Drop acpi_bus_get_power()
Date: Wed, 1 Dec 2010 23:07:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl> <201011250012.06151.rjw@sisk.pl> <alpine.LFD.2.00.1012011702210.2314@x980>
In-Reply-To: <alpine.LFD.2.00.1012011702210.2314@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012012307.30539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 01, 2010, Len Brown wrote:
>   CC [M]  drivers/platform/x86/fujitsu-laptop.o
> drivers/platform/x86/fujitsu-laptop.c: In function ‘acpi_fujitsu_add’:
> drivers/platform/x86/fujitsu-laptop.c:692: error: implicit declaration of 
> function ‘acpi_bus_get_power’

Please see:

https://patchwork.kernel.org/patch/360022/

Thanks,
Rafael
