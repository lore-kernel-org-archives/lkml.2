Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0EUXqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 19:46:32 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:38239 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0EUXqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 19:46:30 -0400
X-MXL-Hash: 4bf71b566a7065ed-6b4fbfc810870b087c338179bb2fd721e59fdb10
X-MXL-Hash: 4bf71b527d7f0d23-269d66ffe5dfc6af0071d04424ee1f14441e1474
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Fri, 21 May 2010 18:46:20 -0500
Subject: RE: [PATCH] pcm551.c: use pci_ids.h defines
Thread-Topic: [PATCH] pcm551.c: use pci_ids.h defines
Thread-Index: Acr5P3VjHdBkzqzNSKS1YgjSDyo09gAADXiA
Message-ID: <0D753D10438DA54287A00B0270842697636F3238BB@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636F3238A0@AUSP01VMBX24.collaborationhost.net>
 <20100521234232.GA31672@kroah.com>
In-Reply-To: <20100521234232.GA31672@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010051701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=YsVMvEm0jmgA:10 a=ood2b7iyd8MA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=MC]
X-AnalysisOut: [SRAonWMXcn6uiOnNkA:9 a=EB9_izpNaY5GG7NwAjqQ23ca_ZwA:4 a=Cj]
X-AnalysisOut: [uIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 21, 2010 4:43 PM, Greg KH wrote:
> On Fri, May 21, 2010 at 06:24:01PM -0500, H Hartley Sweeten wrote:
>> Move the DEVICE id to pci_ids.h and then use the VENDOR/DEVICE ids provided
>> in pci_ids.h instead of creating local ids.
>
> Did you read the comment at the top of the pci_ids.h file saying not to
> do this?  Just use the vendor id that is already in the pci_ids.h file
> in the driver, but leave the device id in the driver itself.

Oops.. My bad, sorry.

Please ignore this patch (and the other two).

Regards,
Hartley