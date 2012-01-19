Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2ASSCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:02:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2ASSCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:02:37 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tom Weber <l_linux-kernel@mail2news.4t2.com>
Subject: Re: 3.2.0 reboot powers off machine
Date: Thu, 19 Jan 2012 19:02:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1326279818.24835.12.camel@utumno>
In-Reply-To: <1326279818.24835.12.camel@utumno>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201191902.32402.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 11 stycznia 2012 o 12:03:38 Tom Weber wrote:
> Hi,
> 
> with 3.2.0 I end up with a powered down machine when trying to reboot.
> shutdown -r, reboot, reboot -f, echo b > /proc/sysrq-trigger
> will all result in power off.
> 
> 3.1.8 reboots as expected.
> 
> 64bit
> Xeon E31240 CPU
> Supermicro X9SCA-F Mainboard
> (http://www.supermicro.nl/products/motherboard/Xeon/C202_C204/X9SCA-F.cfm)
> 
> dmidecode and both kernel configs at http://www.4t2.org/rebootinfo/
> 
> let me know if you need more info,
>   Tom
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42610
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.mrutecki.pl
