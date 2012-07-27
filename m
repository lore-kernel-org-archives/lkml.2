Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2G0HK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 03:10:27 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:33422
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab2G0HKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 03:10:25 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6R7ANjn000984
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] netconsole.txt: "nc" needs "-p" to specify the listening port
Date: Fri, 27 Jul 2012 08:35:28 +0200
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Message-ID: <gir4rxk7c2.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Fri, 27 Jul 2012 09:10:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

I would like to ask you to check if the documentation of "nc" in
netconsole.txt is still correct.  I tried two different netcat packages
and both require "-p" to specify the listening port.  I am wondering if
that changed after the use of "nc" has been documented.

Best regards,

Dirk

Signed-off-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
---
 Documentation/networking/netconsole.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 8d02207..ffe30a7 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -52,7 +52,7 @@ initialized and attempts to bring up the supplied dev at the supplied
 address.
 
 The remote host can run either 'netcat -u -l -p <port>',
-'nc -l -u <port>' or syslogd.
+'nc -l -u -p <port>' or syslogd.
 
 Dynamic reconfiguration:
 ========================
-- 
1.7.8.6
