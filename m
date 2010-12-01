Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0LAWDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 17:03:03 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:65306 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0LAWDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 17:03:01 -0500
Date: Wed, 01 Dec 2010 17:02:37 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 12/13] ACPI / PM: Drop acpi_bus_get_power()
In-reply-to: <201011250012.06151.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.1012011702210.2314@x980>
References: <201011250001.11297.rjw@sisk.pl> <201011250012.06151.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1586859742-1291240960=:2314"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1586859742-1291240960=:2314
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

  CC [M]  drivers/platform/x86/fujitsu-laptop.o
drivers/platform/x86/fujitsu-laptop.c: In function ¡acpi_fujitsu_add¢:
drivers/platform/x86/fujitsu-laptop.c:692: error: implicit declaration of 
function ¡acpi_bus_get_power¢

--8323328-1586859742-1291240960=:2314--
