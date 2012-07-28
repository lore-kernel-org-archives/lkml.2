Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2G1ACt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 20:02:49 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:45755 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2G1ACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 20:02:48 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC ebeam PATCH 0/3] new USB eBeam input driver
Date: Sat, 28 Jul 2012 02:02:31 +0200
Message-Id: <1343433754-3887-1-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is a test-drive for a new USB input driver for eBeam
devices.
Currently, only the Luidia eBeam classic projection model is supported
(usb id known).

Patch 1 and 2 are here to let the ebeam driver be choose to handle
the device instead of the generic-usb hid one (totally useless).

Patch 3 is the actual driver.
Some things to consider :
- I'm not familiar with kernel coding (i've based my work on
  usbtouchscreen.c) so the code certainly contain flaws.
- There's 2 64/64-bits divisions needed, don't know how to handle that the
  right way to be efficient and portable.
- There's 14 custom sysfs files. Yes.

Beside this, the driver run fine with 3.3.6 and 3.5.0 kernels on x86_64.

Thanks for your help.
