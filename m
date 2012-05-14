Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2ENPxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:53:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36660 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2ENPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:53:00 -0400
MIME-Version: 1.0
Date: Mon, 14 May 2012 09:52:59 -0600
Message-ID: <CADLC3L0kMzakdQunStegKeYmp5vxTCniNjrQFocKpJ5qSNeSxg@mail.gmail.com>
Subject: 3.3.6 boot failure regression
From: Robert Hancock <hancockrwd@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an HP Elite 8200 machine (Intel Sandy Bridge CPU, Cougar Point
chipset), 3.3.6 hangs up on boot right after "Probing EDD.. ok". There
is no more output after that, though it does respond to Ctrl-Alt-Del
to reboot. 3.3.5 worked fine. I am using the kernel-ml RPM builds from
ELRepo for Scientific Linux 6.

Any suggestions on boot options, etc. to help narrow it down?
Compiling a custom kernel would be somewhat inconvenient on this
machine.
