Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2HBM7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:59:46 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:55800 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2HBM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:59:42 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC ebeam PATCH v2 0/3] new USB eBeam input driver
Date: Thu,  2 Aug 2012 14:59:54 +0200
Message-Id: <1343912397-18353-1-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Second test-drive for a new USB input driver for eBeam
devices.

Following Dmitry's advice, i've remove device specific infrastructure.

Currently, only the Luidia eBeam classic projection model is supported.

Patch 1 and 2 are here to let the ebeam driver be choose to handle
the device instead of the generic-usb hid one (totally useless).

Patch 3 is the actual driver.
Some things to consider :
- I'm not familiar with kernel coding (i've based my work on
  usbtouchscreen.c) so the code certainly contain flaws.
- There's 2 64/64-bits divisions needed, don't know how to handle that the
  right way to be efficient and portable.
- There's 14 custom sysfs files. Yes.

The module run fine with a 3.3.6 and a 3.5.0 kernel.

Thanks for your help.

