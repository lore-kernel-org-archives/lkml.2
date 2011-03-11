Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1CKPz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:55:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1CKPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:55:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <roger.quadros@nokia.com>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 11 Mar 2011 16:55:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, ext Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <4D79F068.2080009@linaro.org> <201103111622.10722.arnd@arndb.de> <4D7A44E0.5080605@nokia.com>
In-Reply-To: <4D7A44E0.5080605@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111655.45832.arnd@arndb.de>
X-Provags-ID: V02:K0:NsZR3B3m1SeRr1ZZ3Jkag9YRoazWlhDwVKqWOgwMDka
 ILBZt9xFAcGa2yPDduRRsBYn87Y5KWSXRAcNTvSlG9+OP3eRz5
 G1UgK3kBq0PDdsyTVKIjb4FDS8iF6uDCjVEHcF3hXcj4lji1n/
 y4cDARL9XgyHpJ2gHC+ABg29YxCzMPFju7WmUzxp95LwYRjBB+
 2AtBBLO6DgJIH8eCPgsWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Roger Quadros wrote:
> > A udev rule would solve the problem at hand, but I'd consider that
> > an ugly workaround as well. The naming in the kernel is really
> > bogus -- any USB device that has a fixed address gets treated
> > as eth0, while others become usb0, with the same driver,
> > see the code fragment below.
> 
> but isn't that sensible? a real ethernet hardware will have a MAC
> address. no?

I have just verified with my Pandaboard that the pins on the SMSC9514
usb ethernet that are meant to be connected to a serial EEPROM are
indeed not connected anywhere.

	Arnd
