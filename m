Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2IRG6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:58:09 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:54992 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab2IRG6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:58:06 -0400
Date: Tue, 18 Sep 2012 08:58:01 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3]: ezusb FX2 support, firmware downloading support
Message-ID: <bb6a1493-77bc-4d4e-ac2a-92cd8dc2f156@shmail0>
In-Reply-To: <c6dd1b59-bdc4-4575-9e30-1b5a46b112ea@shmail0>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [77.5.123.189]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is v3 of a patches-series for controllers using the ezusb-functions.

euzsb: add support for Cypress FX2LP
ezusb: add functions for firmware download
ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc

--
René Bürgel

SOHARD Embedded Systems GmbH
