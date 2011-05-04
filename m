Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1EDQ4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:56:06 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:49020 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1EDQ4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:56:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "gregkh@suse.de" <gregkh@suse.de>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: Tree for May 4 (hyperv / vmbus)
Thread-Topic: linux-next: Tree for May 4 (hyperv / vmbus)
Thread-Index: AQHMCntOk+LR4a+Ld0eJSEbT0o5RQpR84xkw
Date: Wed, 4 May 2011 16:56:02 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DFD54@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
 <20110504094908.b8295d22.randy.dunlap@oracle.com>
In-Reply-To: <20110504094908.b8295d22.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of Randy Dunlap
> Sent: Wednesday, May 04, 2011 12:49 PM
> To: Stephen Rothwell; driverdevel; gregkh@suse.de
> Cc: Haiyang Zhang; linux-next@vger.kernel.org; LKML
> Subject: Re: linux-next: Tree for May 4 (hyperv / vmbus)
> 
> On Wed, 4 May 2011 14:47:59 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> >
> > Changes since 20110503:
> 
> 
> when CONFIG_ACPI is not enabled:
> 
> 
> drivers/staging/hv/vmbus_drv.c:736: warning: 'struct acpi_device' declared inside
> parameter list
> drivers/staging/hv/vmbus_drv.c:736: warning: its scope is only this definition or
> declaration, which is probably not what you want
> drivers/staging/hv/vmbus_drv.c: In function 'vmbus_acpi_add':
> drivers/staging/hv/vmbus_drv.c:741: error: dereferencing pointer to incomplete
> type
> drivers/staging/hv/vmbus_drv.c: At top level:
> drivers/staging/hv/vmbus_drv.c:758: error: variable 'vmbus_acpi_driver' has
> initializer but incomplete type
> drivers/staging/hv/vmbus_drv.c:759: error: unknown field 'name' specified in
> initializer
> drivers/staging/hv/vmbus_drv.c:759: warning: excess elements in struct initializer
> drivers/staging/hv/vmbus_drv.c:759: warning: (near initialization for
> 'vmbus_acpi_driver')
> drivers/staging/hv/vmbus_drv.c:760: error: unknown field 'ids' specified in
> initializer
> drivers/staging/hv/vmbus_drv.c:760: warning: excess elements in struct initializer
> drivers/staging/hv/vmbus_drv.c:760: warning: (near initialization for
> 'vmbus_acpi_driver')
> drivers/staging/hv/vmbus_drv.c:761: error: unknown field 'ops' specified in
> initializer
> drivers/staging/hv/vmbus_drv.c:761: error: extra brace group at end of initializer
> drivers/staging/hv/vmbus_drv.c:761: error: (near initialization for
> 'vmbus_acpi_driver')
> drivers/staging/hv/vmbus_drv.c:763: warning: excess elements in struct initializer
> drivers/staging/hv/vmbus_drv.c:763: warning: (near initialization for
> 'vmbus_acpi_driver')
> drivers/staging/hv/vmbus_drv.c: In function 'vmbus_acpi_init':
> drivers/staging/hv/vmbus_drv.c:771: error: implicit declaration of function
> 'acpi_bus_register_driver'
> drivers/staging/hv/vmbus_drv.c: In function 'vmbus_acpi_exit':
> drivers/staging/hv/vmbus_drv.c:780: error: implicit declaration of function
> 'acpi_bus_unregister_driver'
> make[4]: *** [drivers/staging/hv/vmbus_drv.o] Error 1
> make[3]: *** [drivers/staging/hv] Error 2
> 
> 
> 
> 
> 
> vmbus_drv.c sure looks like it requires (depends on) both ACPI and PCI.
> That should be expressed somewhere in its Kconfig file.

Greg,

Do you want me to send you a patch to fix this?

Regards,

K. Y
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

