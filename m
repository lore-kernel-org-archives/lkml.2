Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0IESiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:38:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0IESiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:38:10 -0400
Message-ID: <4C83E3C9.7050603@steinhoff.de>
Date: Sun, 05 Sep 2010 20:39:05 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PC/104 interrupt bug] Fedora 13 problem
References: <4C7DFF2C.8070709@steinhoff.de> <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com> <4C7F78CA.3020506@steinhoff.de> <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
In-Reply-To: <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ZfWQEhluUGaBQNqhW/zoL6W5AkxacpTsCDqhkOULFKp
 ingDEaZMnCjmOQ7tscM9Nn0wVVPLUTUt5C0C0lo1zPuHADwVtE
 UMsCt/aaOTaPgBOCujduPF3UDbp2TpDPDuWU7ly5+EIUHRrhYK
 q61vk9gBD0fjYCqph9E7GDbSDe3pFw+ojYrpGtYf6OT3LkmzxS
 GPJpeLed4kjRYIh1ekcyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm developing a driver for a PC/104 board and see that the flag  
IRQF_TRIGGER_RISING has no effect with
a request_irq() call.

The related interrupt pin of the PIC / APIC isn't after the 
request_irq() call reconfigured for handling of an ISA interrupt !
The ISA interrupt is connected to a pull down resistor ... which leads 
to a catastrophic crash when that ISA interrupt line is handled as a PCI 
interrupt line.

Is this by design - that means no ISA interrupt supported -  or is it a 
bug ?

--Armin



