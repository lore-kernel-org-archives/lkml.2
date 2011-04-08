Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1DHTqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:46:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58661 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab1DHTqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oF9vjiSiiyF9pM+25WK2GAdPfrVzv6HcWPRC1sabhNdGJlpUE2fyacGCqhYxA/hyr7
         5G0B6p5HVjLWpQQxGdZiJCT5ePdR4cOPappv4CuUClZFZo44euk79QoNslUDq/6kRMZf
         ehIVeL0yua8S03S5TM2qiIQsSj+F2VZUa/zm4=
MIME-Version: 1.0
In-Reply-To: <1302290881.1664.7.camel@Joe-Laptop>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
	<1302290881.1664.7.camel@Joe-Laptop>
Date: Fri, 8 Apr 2011 21:46:19 +0200
Message-ID: <BANLkTi=QwBOxfxy13PxeX+LRuccV_p06zA@mail.gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Joe Perches <joe@perches.com>:
> On Fri, 2011-04-08 at 21:45 +0200, Rafał Miłecki wrote:
>> diff --git a/include/linux/axi/axi.h b/include/linux/axi/axi.h
> []
>> +#define axi_info     pr_info
>> +#ifdef CONFIG_AXI_DEBUG
>> +#define axi_debug    pr_debug
>> +#else
>> +#define axi_debug    do { } while (0)
>> +#endif
>> +#define axi_err              pr_err
>
> I think redefining standard functionality like
> this doesn't gain anything and loses some basic
> grep capability.

But on the other hand using:
pr_info, pr_err, BUT axi_debug
can easily lead to mistakes.

Or is this possible to re-define pr_debug locally?

-- 
Rafał
