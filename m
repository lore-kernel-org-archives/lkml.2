Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab0GTQIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 12:08:20 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46416 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab0GTQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 12:08:17 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next] drivers/acpi/acpica/utmisc.c: Use printk extension %pV
Date: Tue, 20 Jul 2010 10:08:04 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <1279602367.19374.20.camel@Joe-Laptop.home>
In-Reply-To: <1279602367.19374.20.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201008.04496.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 19, 2010 11:06:07 pm Joe Perches wrote:
> Consolidates the printk messages to a single
> call so the messages can not be interleaved.
> 
> Reduces text a bit.
> 
> $ size drivers/acpi/acpica/utmisc.o.*
>    text	   data	    bss	    dec	    hex	filename
>    7822	     56	   1832	   9710	   25ee	drivers/acpi/acpica/utmisc.o.old
>    7748	     56	   1736	   9540	   2544	drivers/acpi/acpica/utmisc.o.new
> 
> Depends on net-next commit 7db6f5fb65a82af03229eef104dc9899c5eecf33
> (vsprintf: Recursive vsnprintf: Add "%pV", struct va_format)

drivers/acpi/acpica/utmisc.c is part of the ACPI CA and is used in
several different OSes, but %pV sounds like a Linux-specific feature,
so I don't see how this patch can work.

Bjorn
