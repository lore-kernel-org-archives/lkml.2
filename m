Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1CQFuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:50:02 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40102 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1CQFuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=ZKnW5yOyvtzzkDNwIDA+T11DpmHcdwmXTRzb6TUUKt2NbTu0k0uveXM4KszOLC5yw2
         wweSw4VeUyi+Hb/pPFFGSnZP6VuOsxL8xEST4J1rP9tghNNztX47YI9US3Cqa6K/RYfG
         2bdhPRT4mOZHhRr/cGTu2GAfjVylUyw6TEUEc=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <694698.37646.qm@web120506.mail.ne1.yahoo.com>
References: <694698.37646.qm@web120506.mail.ne1.yahoo.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 17 Mar 2011 13:49:28 +0800
Message-ID: <AANLkTimzto6-fhgH25bh09DfReuTawXR9V_9PZMx9djA@mail.gmail.com>
Subject: Re: [PATCH] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate compile warning
To: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Mark Jackson <mpfj@mimc.co.uk>,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Dennis,

2011/3/17 Dennis Aberilla <denzzzhome@yahoo.com>:
> Hi Axel, that doesn't seem to make sense to me since "platform_get_drvdata" is (from include/linux/platform_device.h):
>
> #define platform_get_drvdata(_dev)      dev_get_drvdata(&(_dev)->dev)

These drivers are registered as spi drivers, not platform drivers.
How about using spi_get_drvdata instead.

Regards,
Axel
