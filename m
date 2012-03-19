Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2CSB7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 21:59:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48458 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab2CSB67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 21:58:59 -0400
MIME-Version: 1.0
From: Andrey Moshbear <andrey.vul@gmail.com>
Date: Sun, 18 Mar 2012 21:58:37 -0400
Message-ID: <CAFnZeoRg_uU6wH3Bb8Lapkr_3oDGL0nqh0o17ePK2M1Jj2C86A@mail.gmail.com>
Subject: usb-storage: don't remove device if unrecognized partition table
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to set the kernel to not unregister a USB mass storage
device if the partition table is unrecognized?

I have a Xbox 360 HD connected to a generic SATA-USB bridge, but the
proprietary partition table means that the
device unregisters before I have a chance to intercept in, e.g. virtualbox.

Where, in the usb code, need I comment a few lines to disable this behavior?

001100 Andrey "m05hbear" Vul
010010
011110 andrey at moshbear dot net
100001 andrey dot vul at gmail
101101
110011
