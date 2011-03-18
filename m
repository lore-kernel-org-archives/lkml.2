Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1CROsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:48:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60991 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1CROr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=dad2oZjciSh6UXjZ5jsI11qsU5uImrqQT7TwPX8uLDo/ElTiZz3IR/oUD7rP1/aT+V
         aZzY23wxEY257i7Xz9LFDmB3kbYFffIYuvTrHaGtQbbGtuZi6wXuivjS8tbV5dJnYTbr
         LOY9992d25pck5SWZQQ47RwzaAu3N3hdH+DRs=
Message-ID: <4D837095.5040307@linaro.org>
Date: Fri, 18 Mar 2011 14:47:49 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Premi, Sanjeev" <premi@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [RFC PATCH 2/5] OMAP2+: add cpu id register to MAC address helper
References: <20110312224440.27728.60593.stgit@otae.warmcat.com> <20110312225047.27728.1835.stgit@otae.warmcat.com> <201103180934.39997.arnd@arndb.de> <B85A65D85D7EB246BE421B3FB0FBB593024C3B8670@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C3B8670@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 02:37 PM, Somebody in the thread at some point said:

Hi -

> [sp] This 'trick' has been tried earlier in u-boot. See:
>       http://www.mail-archive.com/u-boot@lists.denx.de/msg19915.html
>
>       I am also not sure whether DIE_ID would really be unique.

It doesn't actually need all the bits to be unique for this, just have a 
low probability of collision with a reasonable number of devices sharing 
the same network.

If there is not enough variation as it stands in the first 6 bytes of 
it, all the 128 bit ID can be xor'd together, use the other registers 
about die revision, hawkeye also xored in, etc.

I'll ask about what can be expected from this at TI.

-Andy
