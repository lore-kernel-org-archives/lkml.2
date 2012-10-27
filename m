Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2J0Qfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:35:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50577 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab2J0Qfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:35:37 -0400
Message-ID: <508C0D55.30205@gmail.com>
Date: Sat, 27 Oct 2012 18:35:33 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mvebu: support for the Globalscale Mirabox MBX0001
 board
References: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com> <20121027183326.62ab505a@skate>
In-Reply-To: <20121027183326.62ab505a@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 06:33 PM, Thomas Petazzoni wrote:
> On Sat, 27 Oct 2012 18:22:45 +0200, Gregory CLEMENT wrote:
>> This platform, available from Globalscale has an Armada 370. For now,
>> only the serial port is supported. Support for network, USB and other
>> peripherals will be added as drivers for them become available for
>> Armada 370 in mainline.
>
> Great!

ACK!

>> +++ b/arch/arm/boot/dts/mbx001.dts
>
> If you decided to name your platform with four zeros (00001), then the
> file should be mbx0001.dts here.

What is wrong with "globalscale,mirabox" ?

Sebastian
