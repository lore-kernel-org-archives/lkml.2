Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0FNRzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:55:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47882 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0FNRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GhWn4iGqFK0cSwazffgXzUu0e83ZOBD/Uob0XuN5kNdlNQhh5mibi9HbunJyufx6O/
         dfOH78q4TWSp5KI9ujjpApOPtrYVOcZmMsfNutMAl01NPxqZFK6BS+gNoztiaIN44w7r
         2o67cSN1X8JWqH7kQAl1fmemso4lEMDTYNkoY=
Subject: Re: [REGRESSION] [IWL3945] Broadcast is broken?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: maciej.rutecki@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       wey-yi.w.guy@intel.com, ilw@linux.intel.com,
       linux-wireless@vger.kernel.org, Berg Johannes <johannes.berg@intel.com>,
       iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <201006141924.24061.maciej.rutecki@gmail.com>
References: <201006141924.24061.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 20:55:38 +0300
Message-ID: <1276538138.7931.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 19:24 +0200, Maciej Rutecki wrote: 
> Hardware:
> 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] 
> Network Connection (rev 02)
> 
> Last known good kernel: 2.6.34
> 
> Failing kernels: since 2.6.35-rc1 to 2.6.35-rc3
> 
> Symptoms:
> During connect do wireless network authentication seems be OK, but I cannot 
> get IP from dhcp serwer. I do:
> echo 0x43fff > /sys/class/net/wlan0/device/debug_level
> 
> Syslog is here:
> http://unixy.pl/maciek/download/kernel/2.6.35-rc3/gumis/syslog-before.txt
> 
> From syslog I guess the problem is that it doesn't receive broadcast frames 
> (but I'm not sure), so I try:
> sudo ifconfig wlan0 promisc
> 
> Syslog:
> http://unixy.pl/maciek/download/kernel/2.6.35-rc3/gumis/syslog-after.txt
> 
> And then I can get IP address.
> 
> Any advice?

Very likely commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4, 
because I have same problem.

Try to revert it.

Best regards,
Maxim Levitsky


