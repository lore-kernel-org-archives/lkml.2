Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2LQXI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:08:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36405 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2LQXI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:08:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, tony.luck@intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [Update][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Tue, 18 Dec 2012 00:14:07 +0100
Message-ID: <2060590.cp1T7dj8Mz@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121217184405.GB4945@kroah.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <4085861.TBmZVTPOvU@vostro.rjw.lan> <20121217184405.GB4945@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 17, 2012 10:44:05 AM Greg Kroah-Hartman wrote:
> On Mon, Dec 17, 2012 at 01:20:15PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The ACPI handles of PCI root bridges need to be known to
> > acpi_bind_one(), so that it can create the appropriate
> > "firmware_node" and "physical_node0" files for them, but currently
> > the way it gets to know those handles is not exactly straightforward
> > (to put it lightly).
> 
> That's just crazy, thanks for unwinding this mess, nice job.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
