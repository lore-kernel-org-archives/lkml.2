Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2AEAPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:15:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50535 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2AEAPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:15:44 -0500
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/3] Input: Cypress TTSP device driver
Date: Thu,  5 Jan 2012 01:16:23 +0100
Message-Id: <1325722586-12886-1-git-send-email-javier@dowhile0.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress TrueTouch(tm) Standard Product controllers are found in a wide range of
embedded devices. This patch-set adds support for a variety of TTSP controllers.

The original author of the driver is Kevin McNeely <kev@cypress.com>

Since the hardware is capable of tracking identifiable contacts and the original
driver used multi-touch protocol type A (stateless), Multi-touch protocol type B
(stateful) support was added and lots of cleanups were made for upstream submission.

The driver is composed of a core driver that process the data sent by the
contacts (fingers) and two bus specific interface modules (I2C and SPI).

This is a version 8 of the driver that fixes issues called out by
Dmitry Torokhov, Henrik Rydberg, Mohan Pallaka and Shubhrajyoti Datta.

The patchset is composed of the following patches:

[PATCH v8 1/3] Input: cyttsp - Cypress TTSP capacitive multi-touch screen support
[PATCH v8 2/3] Input: cyttsp - add support for Cypress TTSP touchscreen I2C bus interface
[PATCH v8 3/3] Input: cyttsp - add support for Cypress TTSP touchscreen SPI bus interface

Best regards,
Javier
