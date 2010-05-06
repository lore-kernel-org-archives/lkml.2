Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab0EFPHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:07:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63991 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0EFPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:07:45 -0400
Date: Thu, 6 May 2010 08:07:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (acpi: PCI=n)
Message-Id: <20100506080722.3b724475.randy.dunlap@oracle.com>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BE2DB3E.0024:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 15:15:02 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100505:


When CONFIG_PCI is not enabled:

arch/x86/kernel/acpi/boot.c:1034: error: 'pci_bus_type' undeclared

drivers/acpi/reboot.c:30: error:implicit declaration of function 'pci_find_bus'
drivers/acpi/reboot.c:30: warning: assignment makes pointer from integer without a cast
drivers/acpi/reboot.c:38: error:implicit declaration of function 'pci_bus_write_config_byte'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
