Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2KZTd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:33:26 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29709 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2KZTdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:33:25 -0500
Message-ID: <1353957902.26955.133.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via
 .sys_notify
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Date: Mon, 26 Nov 2012 12:25:02 -0700
In-Reply-To: <1903623.OrgcmFxHZC@vostro.rjw.lan>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
	 <1352406227-32629-2-git-send-email-toshi.kani@hp.com>
	 <1534747.XBnkTFzSlv@vostro.rjw.lan> <1903623.OrgcmFxHZC@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  {
> > > -	struct acpi_device *device = NULL;
> > > -	struct acpi_driver *driver;
> > > -
> > >  	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
> > >  			  type, handle));
> > >  
> > > -	blocking_notifier_call_chain(&acpi_bus_notify_list,
> > > -		type, (void *)handle);
> 
> By the way, there is exacly one user of this chain, which is dock.c.
> 
> What about convering that to something different and dropping the chain to
> start with?

I agree.  I will look further to see what interface we can use to
replace it.

Thanks,
-Toshi

