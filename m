Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2LCLQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:16:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:54270 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2LCLQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,205,1355126400"; 
   d="scan'208";a="175377208"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 0/5] serial: 8250: 8250_dw changes and dynamic capabilities
Date: Mon,  3 Dec 2012 13:17:54 +0200
Message-Id: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since v1:
- rebased on top of Greg's tty-next

These are mainly small 8250_dw.c changes. The interesting patch is
probable the first one that changes 8250.c so the drivers are able to
deliver their UART's capabilities when they are registering ports.


Heikki Krogerus (5):
  serial: 8250: Allow drivers to deliver capabilities
  serial: 8250_dw: Don't use UPF_FIXED_TYPE
  serial: 8250_dw: Map IO memory
  serial: 8250_dw: Move device tree code to separate function
  serial: 8250_dw: Set FIFO size dynamically

 drivers/tty/serial/8250/8250.c    |   22 ++++--
 drivers/tty/serial/8250/8250_dw.c |  140 +++++++++++++++++++++++++++----------
 2 files changed, 120 insertions(+), 42 deletions(-)

-- 
1.7.10.4

