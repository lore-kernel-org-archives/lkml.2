Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2HCPNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:13:32 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:56085 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2HCPNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:13:30 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2012 11:13:29 EDT
Message-ID: <501BE8F3.6020608@sohard.de>
Date: Fri, 03 Aug 2012 17:06:27 +0200
From: =?ISO-8859-15?Q?Ren=E9_B=FCrgel?= <rene.buergel@sohard.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3]: ezusb cleanup, FX2 support, firmware downloading support
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is a patches-series for controllers using the ezusb-functions.

ezusb:  remove dependency to usb_serial interface
euzsb: add support for Cypress FX2LP
ezusb: add functions for firmware download

-- 
René Bürgel

SOHARD Embedded Systems GmbH
Wuerzburger Str. 197
90766 Fuerth

Tel: +49 (0)911 97341-541
Fax: +49 (0)911 97341-510

Geschäftsführer: Sebastian Schnitzenbaumer, Peter Feltens
Sitz: Fürth; HRB 11482 beim Amtsgericht Fürth

USt-IdNr. DE 814982820
St-Nr. 218/137/60182
WEEE-Reg.Nr. DE 70097646

Webseite: http://www.sohard.de
Webshop: http://shop.sohard.de

