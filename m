Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2LSWKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:10:36 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:46462 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LSWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:10:30 -0500
Date: Wed, 19 Dec 2012 17:10:29 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com>
In-Reply-To: <CADpTngWCVWzDY+++q3n5BtcECT4tVeVKvYppj-1UHw0=MLvK3g@mail.gmail.com>
Subject: Re: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.112]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC23 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Fabio Coatti" <fabio.coatti@gmail.com>
> To: linux-kernel@vger.kernel.org
> Sent: Wednesday, 19 December, 2012 5:01:30 PM
> Subject: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
> 
> Hi,
> I'm testing kernels 3.7.X vs 3.6.11 on an HP Folio 9470m machine,
> i915
> driver for a VGA compatible controller: Intel Corporation 3rd Gen
> Core
> processor Graphics Controller (rev 09) 8086:0166
> 
> With 3.6.11, the brightness can be correctly set using fn+f9/10: kde
> shows the bar and brightness changes.
> 
> With 3.7.1 kde shows the percentage bar and
> /sys/class/backlight/acpi_video0/brightness is updated, but the
> screen
> brightness does not changes.

I had a similar problem with my Dell laptop and i915/acpi...

Is there another acpi_video? device?  In my case two showed up in 3.7 whereas in 3.6 there was one.  In 3.7 it was controlling the wrong one apparently.

Tom St Denis
