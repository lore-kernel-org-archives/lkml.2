Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1ICFvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:51:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1ICFu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:50:58 -0400
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Kevin McNeely <kev@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] Input: Cypress TTSP device driver
Date: Sat,  3 Sep 2011 07:50:39 +0200
Message-Id: <1315029042-27513-1-git-send-email-martinez.javier@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress TrueTouch(tm) Standard Product controllers are found in
a wide range of embedded devices. This patchset adds support for a
variety of TTSP controllers.

The original author of the driver is Kevin McNeely <kev@cypress.com>

Since the hardware is capable of tracking identifiable contacts and the
original driver used multi-touch protocol type A (stateless), I've added
multi-touch protocol type B (stateful) support.

The driver is composed of a core driver that process the data sent by
the contacts (fingers) and two bus specific interface modules (I2C and SPI).

This is a second version of the driver that fixes a few issues called out by
Dmitry Torokhov.

The patchset is composed of the patches:

[PATCH V2 1/3] Input: cyttsp - Cypress TTSP capacitive touchscreen support
[PATCH V2 2/3] Input: cyttsp - add support for Cypress TTSP I2C bus interface
[PATCH V2 3/3] Input: cyttsp - add support for Cypress TTSP SPI bus interface
