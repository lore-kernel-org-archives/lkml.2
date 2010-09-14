Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0INGL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:11:58 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:57405 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0INGL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:11:56 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-Serial device driver
Date: Tue, 14 Sep 2010 11:41:42 +0530
Message-Id: <20100914060649.M96376@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100913154843.GA27496@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in> <20100913154843.GA27496@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> usb to serial devices are known for sending data in "chunks", that's the
> way the devices work (cheap, tiny, 8bit microcontrollers in the device)
> and they break things up like this all the time.
> 

 Greg,
      I am able to send data bytes properly.One problem, I am currently facing is to
enable Address parity and Data parity.

For Address parity we have to give a mark parity ( 0x04 ).
For Data parity we have to give a space parity ( 0x05 ).
I don't know how I can enable parity in pl2303.c.

plz help me.

Thanks,
 Raj    


