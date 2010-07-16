Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680Ab0GPOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:08:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654Ab0GPOH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:07:59 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: greg <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 16 Jul 2010 19:37:38 +0530
Subject: RE: [PATCH] drivers:staging:ti-st: make use of linux err codes
Thread-Topic: [PATCH] drivers:staging:ti-st: make use of linux err codes
Thread-Index: Acsk5jbIfmzasnOZTeaBCZVMw/VX5wACZf7Q
Message-ID: <19F8576C6E063C45BE387C64729E7394044EC8274A@dbde02.ent.ti.com>
References: <AANLkTikrtkVSWZoyVL6A0Maa16cKxGUnnuyrRGmpU09z@mail.gmail.com>
	<662196.81557.qm@web94905.mail.in2.yahoo.com>
 <20100716140517.0b8881fa@lxorguk.ukuu.org.uk>
In-Reply-To: <20100716140517.0b8881fa@lxorguk.ukuu.org.uk>
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


> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Friday, July 16, 2010 8:05 AM
> To: Savoy, Pavan
> Cc: greg; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers:staging:ti-st: make use of linux err codes
> 
> Can't answer for GregKH but to me it looks like its heading in the right
> direction with these patches

Thanks Alan, and with 
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=38d9df499dd3125465cf5aed3d3d6d5c26f0645d

which is merged, I suppose the 1st step in avoiding the single device limit was taken.
Please have a look.
The Idea here is to provide a context to the ST driver as a per-ST platform device.
