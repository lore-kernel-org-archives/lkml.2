Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0DLWoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:44:07 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:38983 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753865Ab0DLWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:44:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MVda32OKGCAZxV4PfrYUR9gMGsP3YbJ2haCJemf299lIFMUf/WrFCL0gR6DxaKXNE+BJmTbo3F/PWZGFn5eKw6ipukSm0rh/cF2NNJ3jtMNxQkVjvFAv47+OapKK3Z3V;
Date: Mon, 12 Apr 2010 15:44:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 2/2] x86,pci, acpi: Inherent BUSY flag when
 setup_resource for root bus
Message-ID: <20100412154426.5740e1e0@virtuousgeek.org>
In-Reply-To: <4BC39FAF.4030808@oracle.com>
References: <20100409223532.GC11130@hexapodia.org>
	<4BBFB1D8.6090802@oracle.com>
	<20100410000030.GE11130@hexapodia.org>
	<4BBFD019.9040405@oracle.com>
	<20100410014308.GG11130@hexapodia.org>
	<4BBFD8EF.6020108@oracle.com>
	<20100410015711.GH11130@hexapodia.org>
	<4BBFE66C.2040603@oracle.com>
	<20100412185416.GA19959@hexapodia.org>
	<4BC375D9.4040503@oracle.com>
	<20100412200224.GO11130@hexapodia.org>
	<4BC39FAF.4030808@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010 15:33:19 -0700
Yinghai <yinghai.lu@oracle.com> wrote:

> 
> So make pci root resource from _CRS honor the range We reserve in e820 below 1M
> then  will not assign them to unsigned pci BAR
> 
> -v2: let pci_bus_alloc_resource() honor IORESOURCE_BUSY
>      driver can not use those range, so skip it
> 
> Tested-by: Andy Isaacson <adi@hexapodia.org>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'd like Bjorn to ack this one before it gets applied.

-- 
Jesse Barnes, Intel Open Source Technology Center
