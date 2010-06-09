Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0FIJ30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:29:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47139 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab0FIJ3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bu6ceFGpQsw56MEOpjAjRkFOyKE1PLG8a5kcpk5e448dq0q3lL2fRW4MoDKfcAQXEJ
         pzJlMlqqBR8btrG+tmr6Nk91DtuLoA5PG2ZQEP3gGnoGuF6g9tcKuaLMQHM5V6EA6V9W
         IzfiW53OP7oCz52DjKPHt2kBF1ghr6tkaLhZA=
MIME-Version: 1.0
In-Reply-To: <op.vd0y3ds37p4s8u@pikus>
References: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
	<op.vd0y3ds37p4s8u@pikus>
Date: Wed, 9 Jun 2010 17:29:22 +0800
Message-ID: <AANLkTim6GHWVNvZ1XOJBZiu7ltl7TVpVJwVltLoKpYRi@mail.gmail.com>
Subject: Re: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
From: Xiaofan Chen <xiaofanc@gmail.com>
To: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/9 Michał Nazarewicz <m.nazarewicz@samsung.com>:
> As for CDC ACM INF file, my understanding is similar except the template
> is provided by Microchip rather then Microsoft itself.
>

Actually Microchip is also copying from Microsoft's template.
I could not find the CDC-ACM inf template from Microsoft
website now but I clearly remember I saw it somewhere.

Other companies does not really put Copyrights on the inf file
for usbser.sys, for example, look at the following file from ST.
http://www.st.com/stonline/books/pdf/docs/12571.pdf (page 5).

Another example (old format).
http://www.lvr.com/files/usbcomport.txt

So it is probably okay to drop the copyright line. On the
other hand, even if there is the copyright line from Microsoft,
I think you can still redistribute it. But I am not a lawyer but
a hardware engineer. ;-)


-- 
Xiaofan http://mcuee.blogspot.com
