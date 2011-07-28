Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1G1FnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:43:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40435 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab1G1FnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:43:12 -0400
MIME-Version: 1.0
Date: Thu, 28 Jul 2011 13:43:11 +0800
Message-ID: <CAAJw_ZvnUPs5wD6hU059GcKRkyeNn7Y36fk9nNjNFJ6kNmL0uw@mail.gmail.com>
Subject: How to access serial port that is set in BIOS as OS Controlled
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to access the serial port ttyS2 that is set in the BIOS as
"OS Controlled" without much success. If it's set it to "Always
Enabled",  I can access the serial port.

This is on the Intermec CV60, and ttyS2 is the touchscreen port.

# setserial /dev/ttyS2
/dev/ttyS2, UART: 16550A, Port: 0x03e8, IRQ: 6


If I set the BIOS to "OS Controlled", I can't access the serial port
no matter what parameter I pass to the setserial. The factory default
is "OS Controlled", and Window XP can detect and access the port.
There will be hundreds of CV60 to get into the BIOS to set it one by
one. If there's a way to access the port in linux, it'll be great!

Thanks,
Jeff
