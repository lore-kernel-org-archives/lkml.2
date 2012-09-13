Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2IMUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:01:26 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:43274 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2IMUBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:01:25 -0400
Date: Thu, 13 Sep 2012 22:01:22 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4]: ezusb cleanup, FX2 support, firmware downloading support
Message-ID: <25c2a6f7-a559-4222-9c69-fb1c8229c238@shmail0>
In-Reply-To: <31fec050-3b94-48a1-a147-2c16919245c1@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.190.106.167]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

this is V2 of a patches-series for controllers using the ezusb-functions.

ezusb: remove dependency to usb_serial interface
euzsb: add support for Cypress FX2LP
ezusb: add functions for firmware download
ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc

-- 
René Bürgel

SOHARD Embedded Systems GmbH
