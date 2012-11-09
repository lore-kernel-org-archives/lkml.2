Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2KIVpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:45:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab2KIVp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:45:26 -0500
Date: Fri, 9 Nov 2012 13:45:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: akpm@linux-foundation.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2012-11-08-15-17 uploaded  (acpi)
In-Reply-To: <509D862C.2060408@infradead.org>
Message-ID: <alpine.DEB.2.00.1211091345080.2974@chino.kir.corp.google.com>
References: <20121108231753.E6B7A100047@wpzn3.hot.corp.google.com> <509D862C.2060408@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Randy Dunlap wrote:

> on x86_64:
> 
> drivers/built-in.o: In function `acpi_pm_device_sleep_state':
> (.text+0x21855): undefined reference to `acpi_target_system_state'
> drivers/built-in.o: In function `acpi_pm_device_sleep_wake':
> (.text+0x2198e): undefined reference to `acpi_target_system_state'
> drivers/built-in.o: In function `acpi_dev_suspend_late':
> (.text+0x21add): undefined reference to `acpi_target_system_state'
> 

Sent a fix for this yesterday: 
http://marc.info/?l=linux-kernel&m=13524024192708
