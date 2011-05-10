Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1EJKLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:11:41 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:40164 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab1EJKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:11:39 -0400
Message-ID: <F1859F4DD03040248B42AC947304D39B@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>, "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <Netdev@vger.kernel.org>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        <m-watkins@ti.com>
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <201105041511.54095.arnd@arndb.de> <4DC163D7.9010309@grandegger.com> <201105041648.37199.arnd@arndb.de> <4DC17831.3070801@grandegger.com>
In-Reply-To: <4DC17831.3070801@grandegger.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Tue, 10 May 2011 15:41:49 +0530
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

>> 
>> It sounds to me like the best solution would be change the firmware
>> to lift that restriction and simply allow all IDs, in case it's not
>> actually a hardware limitation (which sounds unlikely).
> 
> Yes, that would be best but they told us, that it's not possible with
> the available hardware resources. Subhasish?

Yes, In case if we allow the ALL implementation, it hogs the CPU.
In that case we do not need the PRU. The whole purpose of the PRU
is to offload the processor for any such implementations. 
