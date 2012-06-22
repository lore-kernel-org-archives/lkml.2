Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485Ab2FVP2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:28:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40767 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762468Ab2FVP2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:28:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/12] 8250: propogate the bugs field
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:44:08 +0100
Message-ID: <20120622154402.1405.86889.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Now we are using the uart_8250_port this is trivial

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/serial/8250/8250.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 5e3f6a3..779d791 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -3147,6 +3147,7 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->port.regshift     = up->port.regshift;
 		uart->port.iotype       = up->port.iotype;
 		uart->port.flags        = up->port.flags | UPF_BOOT_AUTOCONF;
+		uart->bugs		= up->bugs;
 		uart->port.mapbase      = up->port.mapbase;
 		uart->port.private_data = up->port.private_data;
 		if (up->port.dev)

