Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2LLBEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:04:12 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:41079 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2LLBEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:04:08 -0500
Date: Wed, 12 Dec 2012 02:03:48 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jacek Poplawski <jacekpoplawski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "attempt to access beyond end of device" on DVD
Message-ID: <20121212020348.0afa77e2@neptune.home>
In-Reply-To: <CAGDELX6rtztDzQobfaUNB2iZSyxGL9vzu5mM4sG7bDip=SaBag@mail.gmail.com>
References: <CAGDELX7f-Ee-V_M8kbDONRFCTBbZM2H_Q17Bk_12r4xw85Wq4Q@mail.gmail.com>
	<20121212014109.38e18eeb@neptune.home>
	<CAGDELX6rtztDzQobfaUNB2iZSyxGL9vzu5mM4sG7bDip=SaBag@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 December 2012 Jacek Poplawski wrote:
> On 12/12/12, Bruno Prémont wrote:
> > When it happens, does ejecting and re-inserting the CDs/DVDs also fix the
> > problem or is a full reboot mandatory?
> 
> The re-inserting doesn't fix the problem.
> Even worse. When it starts - each next DVD is also affected (until reboot).

Did you check if unbinding drivers or unloading their modules has the
same effect as rebooting? That might help narrowing the area of code to
look at.

Does it also affect loop-mounted ISOs or is it specific to the CD/DVD
drive?
As a related test, does it affect CD/DVD drives connected through a
different interface? (USB storage, ATA over Ethernet, iSCSI, ...)

While at it, please tell us how your CD/DVD drive is connected and which
controller it's connected to (relevant dmesg parts).

Bruno
