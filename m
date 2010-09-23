Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0IWSvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:51:25 -0400
Received: from xenotime.net ([72.52.115.56]:59422 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754339Ab0IWSvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:51:25 -0400
Date: Thu, 23 Sep 2010 11:51:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Anders Wallin <Anders.Wallin@windriver.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com
Subject: Re: [PATCH 0/1] Adding support for STA2x11/ConneXt PCIexpress
 function 0xCC0C.
Message-Id: <20100923115123.7a2e1ade.rdunlap@xenotime.net>
In-Reply-To: <cover.1285266234.git.anders.wallin@windriver.com>
References: <cover.1285266234.git.anders.wallin@windriver.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 20:25:31 +0200 Anders Wallin wrote:

> From: Anders Wallin <anders.wallin@windriver.com>
> 
> This function enable access to multiple IP-blocks including 4 GPIO blocks,
> one System Control block and one Timer block. Access to the PCIe device is managed by a MUX driver. 
> The pl061_pci gpio driver is based on the ARM pl061 IP block, but the functionality is not a one to one map. The gpio driver needs the generic "gpio_to_irq" support.

This patch description should be in patch 1/1.  The diffstat can go there also.
No need to patch 0/1 email at all.

Thanks.


> Anders Wallin (1):
>   Adding support for STA2x11/Connext PCIexpress function 0xCC0C.
> 
>  arch/x86/include/asm/gpio.h   |    2 +-
>  drivers/gpio/Kconfig          |   14 +
>  drivers/gpio/Makefile         |    1 +
>  drivers/gpio/pl061_pci.c      |  860 +++++++++++++++++++++++++++++++++++++++++
>  drivers/gpio/pl061_pci.h      |   29 ++
>  drivers/misc/Kconfig          |   23 ++
>  drivers/misc/Makefile         |    3 +
>  drivers/misc/sta2x11_apbreg.c |  177 +++++++++
>  drivers/misc/sta2x11_apbreg.h |   39 ++
>  drivers/misc/sta2x11_mux.c    |  265 +++++++++++++
>  drivers/misc/sta2x11_mux.h    |   50 +++
>  drivers/misc/sta2x11_sctl.c   |  189 +++++++++
>  drivers/misc/sta2x11_sctl.h   |  143 +++++++
>  13 files changed, 1794 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/gpio/pl061_pci.c
>  create mode 100644 drivers/gpio/pl061_pci.h
>  create mode 100644 drivers/misc/sta2x11_apbreg.c
>  create mode 100644 drivers/misc/sta2x11_apbreg.h
>  create mode 100644 drivers/misc/sta2x11_mux.c
>  create mode 100644 drivers/misc/sta2x11_mux.h
>  create mode 100644 drivers/misc/sta2x11_sctl.c
>  create mode 100644 drivers/misc/sta2x11_sctl.h

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
