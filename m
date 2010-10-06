Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0JFEPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:15:01 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:47846 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab0JFEPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:15:00 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>,
        Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303_ttyUSB0 userspace application not able to control RTS line
Date: Wed, 6 Oct 2010 09:44:38 +0530
Message-Id: <20101006034210.M38114@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20101005133312.GF3548@suse.de>
References: <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in> <20100923140236.GB31394@suse.de> <20100928091520.M79654@admin-gateway.ncra.tifr.res.in> <20100928113036.GA15024@suse.de> <20100928115204.M46802@admin-gateway.ncra.tifr.res.in> <20100928120743.GA15807@suse.de> <20101004042924.M50398@admin-gateway.ncra.tifr.res.in> <20101005104403.M28756@admin-gateway.ncra.tifr.res.in> <20101005133312.GF3548@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Is this your "modified" driver?
   
  No..It's pl2303.

> 
> I don't see that error in the kernel log below at all.

 sometimes I got that error.
 
> What kernel version is this?

 2.6.35

> And are you sure that your device actually has the RTS lines connected?
> I have seen a number of these devices that do not bring those lines from
> the chip to the rs232 connection.

I have connected a RS-485 interface card to this usb-to-serial converter which has
MAX-485 IC ( Line driver chip which convert RS-232 to RS-485),of which pin number 2 is
for RTS line.

Through my modified pl2303 device driver, I am able to enable/disable the RTS line as
per my need,as I told in my earlier email.

> You really might want to go purchase a "real" usb to serial converter
> that works properly, the pl2303 devices do not fit that category.

Yes, I am also thinking of purchasing a "real" usb to serial converter.

Thanks a lot Greg, I have learned a lot interacting with you.


Thanks-
Raj
