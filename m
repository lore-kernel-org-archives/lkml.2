Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0CXVq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:46:58 -0400
Received: from web94906.mail.in2.yahoo.com ([203.104.17.156]:41684 "HELO
	web94906.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751258Ab0CXVq5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:46:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=x9UtFTCOdMWwktRIsY5EgGY6vpgM78hGxosHjrarFwZOxWZMcYp3jr87k2jJCiHgFQAimUUwvned1VeCepGIi8RyWu4UFQgstPXoCv+2HkKbIMMLIpmomwB2X1HvMJkvN707bZ11/oiLLFpeRqkiOcDtLbNVjdEWm1TMiP7MfKc=;
Message-ID: <526700.12048.qm@web94906.mail.in2.yahoo.com>
X-YMail-OSG: Nh9aXiwVM1midtdsJpr_OEtM1gzSs6_wQC3EvS93X6UUfWr
 fE1qBqh0ehRUj6GJYnHohCS1DKlj7AyzkNt02pubGcAq2LV0cGtDZmFclc7w
 ZXAt454VdHV8lRHOY73s92PdljwB_CuFVxUR6hkXo8dYIJ4V1Su0QpyQLJSd
 qKcWrtzT3RNNEG4tdwXRtSZ1GOG.GKGVD37ehTqRW0qEBBDHms_S8y8aNCy8
 7qU6Vbl7drRh_voFIf9nwW4A4QHBvTQm8IbJjJs4fCU2o1ZC6FcV8aP9ly.R
 VHRWLDjVKIJ3aEUi3.noCTQc-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 25 Mar 2010 03:16:54 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: RE: [PATCH 4/6] drivers:misc: sources for Init manager module
To: PavanSavoy <pavan_savoy@ti.com>, Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@suse.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1269466536.11714.144.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 25/3/10, Marcel Holtmann <marcel@holtmann.org> wrote:

> From: Marcel Holtmann <marcel@holtmann.org>
> Subject: RE: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Savoy, Pavan" <pavan_savoy@ti.com>
> Cc: "Pavan Savoy" <pavan_savoy@yahoo.co.in>, "Greg KH" <gregkh@suse.de>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "Deosthali, Amey" <adeosthali@ti.com>, "Alathur, Pramodh" <pramodh_ag@ti.com>
> Date: Thursday, 25 March, 2010, 3:05 AM
> Hi Pavan,
> 
> > Find enclosed the design document, where in figure-1
> pretty much explains the different protocols for FM, GPS, BT
> and HCI-LL.
> 
> just after quickly going through that document, I think you
> should
> create an actual ST bus. The ST line discipline should be
> just one
> transport driver for that bus. Since you clearly looking
> into SPI and
> other transports as well.

Had planned a range of TTY drivers for SPI/SlimBus 'ala usb-serial device driver for that.
And hence somehow assumed TTY line discipline should be enough.

SPI/SlimBus I tend to agree, their device nodes in user space is not used, and settings like bus freq, CPOL/CPHA are all set via drivers (for spi atleast).

Even after doing that, what about the requirement of opening an tty device upon request from BT or FM when chip is on UART ?

> 
> And then the bus can export Bluetooth, FM and GPS devices.
> And we can
> have separate drivers for these devices.

Hnm, Any such example drivers to look around ?

> You might wanna pick a different name than ST to not make
> ST
> Microelectronics unhappy and next time they call their next
> thing TI ;)

I had called it SHUART for some reason earlier, Yep point to be considered.
Thanks,

> Regards
> 
> Marcel
> 
> 
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
