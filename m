Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2KVSzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:55:17 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28057 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2KVSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:55:14 -0500
Message-ID: <1353603178.26301.6.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7-1 1/5] ACPI: Add acpi_handle_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        vijaymohan.pandarathil@hp.com
Date: Thu, 22 Nov 2012 09:52:58 -0700
In-Reply-To: <15759755.f5L9LAVF83@vostro.rjw.lan>
References: <1353461788-808-1-git-send-email-toshi.kani@hp.com>
	 <15759755.f5L9LAVF83@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> > ---
> > 
> > Hi Rafael,
> > This patch replaces the [PATCH v7 1/5] below in the v7 series.
> > https://lkml.org/lkml/2012/11/20/719
> 
> I've applied the entire v7 series to linux-pm.git/linux-next as v3.8 material.

Great!

> As far as the .sys_notify series is concerned, I don't really like it.
> I'll send you my comments in the next few days.

Thanks for reviewing!  Yes, let me know your comments.

-Toshi


