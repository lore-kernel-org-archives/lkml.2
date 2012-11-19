Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2KSDCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 22:02:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59833 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KSDB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 22:01:59 -0500
MIME-Version: 1.0
Date: Mon, 19 Nov 2012 11:01:59 +0800
Message-ID: <CAFCUKTS=SHoD4jpJe0_H6tsKcw-C9bAQP=VhXx+Lp8WZ4Xj6cA@mail.gmail.com>
Subject: [RFC] usb: add 'usb_get_intf()' call into the probe methods of
 drivers for usb interfaces.
From: harvey yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
I checked many usb drivers in the mainline kernel which do not record
this reference in their probe methods. But according to the documents
about this function, we shoud record this reference in our probe
methods, just as the call to 'usb_get_dev()' to reference a usb
device. Are these usb drivers right or we need to fix them?
