Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565Ab2FIBvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 21:51:36 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52533 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933112Ab2FIBvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 21:51:35 -0400
Message-ID: <4FD2AC1B.6070500@xenotime.net>
Date: Fri, 08 Jun 2012 18:51:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] serial: fix kernel-doc warnings in 8250.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in drivers/tty/serial/8250/8250.c:

Warning(drivers/tty/serial/8250/8250.c:3128): No description found for parameter 'up'
Warning(drivers/tty/serial/8250/8250.c:3128): Excess function parameter 'port' description in 'serial8250_register_8250_port'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/tty/serial/8250/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-35-rc1.orig/drivers/tty/serial/8250/8250.c
+++ lnx-35-rc1/drivers/tty/serial/8250/8250.c
@@ -3113,7 +3113,7 @@ static struct uart_8250_port *serial8250
 
 /**
  *	serial8250_register_8250_port - register a serial port
- *	@port: serial port template
+ *	@up: serial port template
  *
  *	Configure the serial port specified by the request. If the
  *	port exists and is in use, it is hung up and unregistered
