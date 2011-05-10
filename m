Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1EJMVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:21:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52872 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1EJMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:21:02 -0400
Message-ID: <2BFFDAA0A0DE4820876E5549867938EC@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>, "Arnd Bergmann" <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <Netdev@vger.kernel.org>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        <m-watkins@ti.com>
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com><201105041511.54095.arnd@arndb.de><4DC163D7.9010309@grandegger.com><201105041648.37199.arnd@arndb.de><4DC17831.3070801@grandegger.com><F1859F4DD03040248B42AC947304D39B@subhasishg> <20110510112734.54160824@lxorguk.ukuu.org.uk>
In-Reply-To: <20110510112734.54160824@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Tue, 10 May 2011 17:51:12 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, In case if we allow the ALL implementation, it hogs the CPU.
>> In that case we do not need the PRU. The whole purpose of the PRU
>> is to offload the processor for any such implementations. 
> 
> So the kernel presumably needs to switch between using the PRU and native
> according to the number of ids being requested at the time ?

All the IDs are programmed into the PRU data RAM.
The Kernel receives interrupts based upon these IDs.
I could not clearly follow "PRU and native", could you please elaborate.

> That would be roughly what we do with other things (eg IP multicast) so
> that apps don't need to know all the innards

 
