Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab2FTXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:16:56 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:38702 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2FTXQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:16:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1340234214!6364965!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Wed, 20 Jun 2012 18:16:52 -0500
Subject: RE: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
Thread-Topic: [PATCH] staging: comedi: skel: use
 module_comedi_{pci_,}driver()
Thread-Index: Ac1POjGFKr2ZrjXKT9mT8tKOeTTwigAABGSw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698E77071@AUSP01VMBX24.collaborationhost.net>
References: <201206201556.51336.hartleys@visionengravers.com>
 <20120620231230.GA28411@kroah.com>
In-Reply-To: <20120620231230.GA28411@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 20, 2012 4:13 PM, Greg KH wrote:
> On Wed, Jun 20, 2012 at 03:56:50PM -0700, H Hartley Sweeten wrote:
>> If PCI boards are supported, use the module_comedi_pci_driver() macro
>> to register the module as a comedi driver and a PCI driver. Otherwise,
>> only ISA boards are supported to use the module_comedi_driver() macro
>> to register the module as a comedi driver.
>> 
>> Refactor the code a bit due to the use of the module_comedi_* macros.
>> 
>> Rename the comedi_driver and pci_driver variables as well as the pci
>> driver related functions for aesthetic reasons. This makes the skel
>> driver conform to the changes to the other comedi drivers.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
>
> This patch fails to apply:
>
> patching file drivers/staging/comedi/drivers/skel.c
> Hunk #4 FAILED at 543.
> 1 out of 4 hunks FAILED -- saving rejects to file drivers/staging/comedi/drivers/skel.c.rej
>
> Care to rediff it and resend?

Hmm. It was based on next-20120620 and created with git format-patch.

Do you have any other patches to that file in your staging tree that
have not reached the next tree yet?

Regardless, I have some other cleanup patches for that file. I'll
put them together as a series and repost it later.

Thanks,
Hartley

