Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1J0QBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:01:35 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:44477 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1J0QBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:01:34 -0400
Message-ID: <4EA9805B.7060506@ilyx.ru>
Date: Thu, 27 Oct 2011 20:01:31 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] TTY: pty, fix pty counting in "/proc/sys/kernel/pty/nr"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excuse me, my persistence.

But, I don't understand, 
what for, "pty" driver, invoked tty_driver_remove_tty(), 
only for call its own function(pty_unix98_remove). 
In commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24.

Thank you.
Ilya.

