Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1AJNHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:07:42 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:47696 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1AJNHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:07:41 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Russell Coker <russell@coker.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 10 Jan 2011 14:06:57 +0100
Message-Id: <1294664819-17960-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.7.0.4
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [Ver. 2] Network Virtual Terminal
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

here my implementation of Network Virtual terminals (NVT tty)
according to RFC 854 and RFC 2217... actually this is the client side
part since as remote server I used sredird
(http://freshmeat.net/projects/sredird/).

I tested the code under the following configuration:

        ------------------+
             +---------+  |
             | minicom |  |
             +---------+  |
                  |       | local PC with no
                  v       | serial ports
             /dev/nvtty0  |
                  |       |
        ------------------+
                  |
                  v
             /\/\/\/\/\
            | network |
             \/\/\/\/\/
                  |
        ------------------+
                  |       |
                  v       |
             +---------+  |
             | sredird |  |
             +---------+  | remote PC with
                  |       | serial ports
                  v       |
             /dev/ttyS0   |
                  |       |
        ------------------+
                  |
                  v
         embedded PC with
         a serial console

however it could work on a different schema I suppose.

By using minicom I can setup the serial settings of the /dev/ttyS0
device through the /dev/nvtty0 virtual device, then the communication
with the embedded PC can start as if it was directly connected with my
local machine.

Ciao,

Rodolfo

--

CHANGELOG:

Ver. 2:

* typo bugs fixed.
