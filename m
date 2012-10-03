Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2JCJtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:49:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36939 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2JCJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:49:08 -0400
MIME-Version: 1.0
Reply-To: rgawenda@gmail.com
Date: Wed, 3 Oct 2012 11:49:07 +0200
Message-ID: <CAPjGNyt36nQZYpXgSj6Qk_gXQ047OvT5mrV0KXK=a1f9LQtPYw@mail.gmail.com>
Subject: Typo in Kconfig for Iguanaworks IR receiver
From: Rafael Gawenda <rgawenda@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-3.6.0-gentoo/drivers/media/rc/Kconfig.orig    2012-10-03
11:37:08.862279049 +0200
+++ linux-3.6.0-gentoo/drivers/media/rc/Kconfig 2012-10-03
11:38:56.832280750 +0200
@@ -265,7 +265,7 @@ config IR_IGUANA
        depends on RC_CORE
        select USB
        ---help---
-          Say Y here if you want to use the IgaunaWorks USB IR Transceiver.
+          Say Y here if you want to use the IguanaWorks USB IR Transceiver.
           Both infrared receive and send are supported.

           To compile this driver as a module, choose M here: the module will
