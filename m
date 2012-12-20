Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2LTJeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:34:05 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58638 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2LTJd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:33:57 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 04:33:56 EST
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Tom St Denis <tstdenis@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
Date: Thu, 20 Dec 2012 10:27:57 +0100
Message-ID: <1425298.zMcaSB7taE@calvin>
User-Agent: KMail/4.9.4 (Linux/3.7.1; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com>
References: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data mercoledì 19 dicembre 2012 17:10:29, hai scritto:
> ----- Original Message -----
> 
> > From: "Fabio Coatti" <fabio.coatti@gmail.com>
> > To: linux-kernel@vger.kernel.org
> > Sent: Wednesday, 19 December, 2012 5:01:30 PM
> > Subject: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
> > 
> > Hi,
> > I'm testing kernels 3.7.X vs 3.6.11 on an HP Folio 9470m machine,
> > i915
> > driver for a VGA compatible controller: Intel Corporation 3rd Gen
> > Core
> > processor Graphics Controller (rev 09) 8086:0166
> > 
> > With 3.6.11, the brightness can be correctly set using fn+f9/10: kde
> > shows the bar and brightness changes.
> > 
> > With 3.7.1 kde shows the percentage bar and
> > /sys/class/backlight/acpi_video0/brightness is updated, but the
> > screen
> > brightness does not changes.
> 
> I had a similar problem with my Dell laptop and i915/acpi...
> 
> Is there another acpi_video? device?  In my case two showed up in 3.7
> whereas in 3.6 there was one.  In 3.7 it was controlling the wrong one
> apparently.

Well, this seems not to be the case, I have only one acpi_video:

calvin ~ # ls -l /sys/class/backlight/
totale 0
lrwxrwxrwx 1 root root 0 20 dic 09.20 acpi_video0 -> 
../../devices/pci0000:00/0000:00:02.0/backlight/acpi_video0

calvin ~ # ls -l /sys/devices/pci0000:00/0000:00:02.0/backlight
totale 0
drwxr-xr-x 3 root root 0 20 dic 09.20 acpi_video0



--
Fabio
