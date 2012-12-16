Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2LPWYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:24:14 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35701 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2LPWYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:24:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Yijing Wang <wangyijing0307@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 0/6] ACPI: Simplify namespace scanning for devices
Date: Sun, 16 Dec 2012 23:29:22 +0100
Message-ID: <2838930.01Rbj0pevt@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50CDEFFE.7030509@gmail.com>
References: <4532917.9APhB4xTvi@vostro.rjw.lan> <50CDEFFE.7030509@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, December 16, 2012 11:59:58 PM Jiang Liu wrote:
> Hi Rafael,
> 	Great idea to get rid of the .start() staff, it could also
> simplify our hotplug framework too.

Well, this has been a Yinghai's idea, but thanks anyway. :-)

I see some more room for improvements like this, for example in the
acpi_pci_bind()/acpi_pci_unbind() area.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
