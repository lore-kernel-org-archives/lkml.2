Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1FIHAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:00:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42868 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1FIHA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BZ3F4XSN0wP4dC9+NgTQtVJckBezTI97F1oUVKLdAfP2ics7Jwy1g93chERKZyildK
         9GqU5eeix4qQM+WexMkcCtUYyBZ/uBqrkKTOkL+IUbJ99ssHRMZV53goX+A5Uh6ra9vC
         WQeAHBYLPPCvQrQwK8Gb0BGpK42Y7T7IbVM+U=
Subject: [linux-next] drivers/gpio/gpio-nomadik.c build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prafulla WADASKAR <prafulla.wadaskar@st.com>,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 15:00:21 +0800
Message-ID: <1307602821.9501.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make nhk8815_defconfig  with below build error:

  CC      drivers/gpio/gpio-nomadik.o
drivers/gpio/gpio-nomadik.c: In function 'nmk_gpio_wakeups_suspend':
drivers/gpio/gpio-nomadik.c:904: error: implicit declaration of function 'cpu_is_u8500v2'
make[2]: *** [drivers/gpio/gpio-nomadik.o] Error 1
make[1]: *** [drivers/gpio] Error 2
make: *** [drivers] Error 2

Regards,
Axel

