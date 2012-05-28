Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2E1KQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:16:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58955 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2E1KQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:16:02 -0400
MIME-Version: 1.0
Date: Mon, 28 May 2012 15:46:00 +0530
Message-ID: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com>
Subject: Break point not hit while debugging linux kernel with kgdb
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to debug the linux kernel with kgdb (over serial port). I have
configured the host and target machines and I am able to connect, step
in the kernel code. In gdb I gave "break usb_register_dev" and "break
usb_deregister_dev" and continued the execution (continue in gdb).
Once the desktop is up, I connected a USB device (first tried with USB
keyboard). Break point was not hit. I tried some more functions and
break points are never hit. What should I do for it? Am I missing
something?

Thanks,
Prasanna Kumar T S M
