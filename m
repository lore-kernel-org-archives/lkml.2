Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab2GCTaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:30:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41460 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2GCTaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:30:04 -0400
Subject: gpio: pch/ml-ioh - leaking struct irq_chip_generic
Content-Transfer-Encoding: 7bit
From: "=?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?=" <jeff.dagenais@gmail.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <B9B2E09D-99AF-4B36-AC3A-7000A3FDCCA9@sonatest.com>
Date: Tue, 3 Jul 2012 15:30:01 -0400
Cc: open list <linux-kernel@vger.kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>, linus.walleij@stericsson.com
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Am I mistaken or these two drivers are missing a "irq_remove_generic_chip()"
then a "kfree" of the struct's memory in their xyz_remove() callbacks?

Kinda like "drivers/mfd/jz4740-adc.c" does?

/jfd
