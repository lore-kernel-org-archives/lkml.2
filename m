Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0IDOVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:21:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0IDOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:21:45 -0400
Message-ID: <4C825629.9090707@steinhoff.de>
Date: Sat, 04 Sep 2010 16:22:33 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [ISA bus] or platform bus ?
References: <4C7DFF2C.8070709@steinhoff.de> <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com> <4C7F78CA.3020506@steinhoff.de> <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
In-Reply-To: <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:USNJWHETskDMllt/eh501WqxePLtTdNH0+Obs7cNYSO
 mMm2oyDvMUd8fxI9XqF0i3SYkxg92S9UF/ddsOieJoFUBIfhex
 FQSosfUl5yPHbVwPKegEKdpOYGxemI/Jsk/OvxLRfygj8RvtMn
 8FlOh9IS0ii0+jyCMyjsIRiZYOPN6zE/X8P03K+md8APVRwUmB
 yRD7WdGN1iWoGOJxpNMRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have developed a UIO based driver using the platform bus. The target 
device is an ISA bus board.

Can an ISA bus board create interrupts for a device based on the 
platform bus ?

I don't see any interrupts. The hardware and BIOS settings are OK .. was 
verified on an other OS.

--Armin



