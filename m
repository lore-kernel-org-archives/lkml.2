Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0G2Nej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:34:39 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:57263 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113Ab0G2Neh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:34:37 -0400
From: Philippe Langlais <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <gregkh@suse.de>,
        <ludovic.barre@stericsson.com>, <vincent.guittot@stericsson.com>
Subject: New U6715 8250 serial patch
Date: Thu, 29 Jul 2010 15:32:27 +0200
Message-ID: <1280410348-28940-1-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the port PORT_U6_16550A (Fifo 64 bytes + Auto flow control),
auto-configuration is based on 64 bytes fifo size.
Move all U6715 specificity into our U6XXX platform serial driver (will be posted
in arm kernel list).
I add a pre_set_termios hunk at serial8250_set_termios() beginning to manage
our uart clock depending on baudrate.
I can't see another way to override 8250 set_termios() and it's enough for us.

Philippe

