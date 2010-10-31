Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0JaRv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:51:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59705 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab0JaRvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:51:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 31 Oct 2010 18:51:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: drivers/media/IR/ir-keytable.c::ir_getkeycode - 'retval' may be used
 uninitialized
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <tkrat.980deadea593e9ed@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9f470095068e "Input: media/IR - switch to using new keycode
interface" added the following build warning:

drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used uninitialized in this function

It is due to an actual bug but I don't know the fix.
-- 
Stefan Richter
-=====-==-=- =-=- =====
http://arcgraph.de/sr/

