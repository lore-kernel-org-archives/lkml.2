Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1JJTIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:08:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61814 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1JJTIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:08:52 -0400
MIME-Version: 1.0
X-Originating-IP: [91.17.208.69]
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Mon, 10 Oct 2011 21:08:31 +0200
Message-ID: <CANvSZQ_h1QbSCWs2tBmOA9FXY=DTcgsom+WG9JJqm8-dm+aNyg@mail.gmail.com>
Subject: Sporadic kernel panic on Lenovo T420s resume from S3
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

recently, my Lenovo ThinkPad T420s has been sporadically crashing
after waking up the machine from ACPI S3. The system locks up hard,
i.e., MagicSysRq no longer works, but at least a dump is printed to
the console. The process that is crashing is a kworker process, the
topmost method on the call stack is "wq_worker_sleeping".

The remaining call stack is available (as a photograph) at:
https://secure.tgbyte.de/dropbox/ieNiema6.jpg

Unfortunately, the top of the panic is not visible and scrolling back
does not work.

Some further details:

$ uname -a
Linux orion 3.1.0-0301rc9-generic #201110050905 SMP Wed Oct 5 09:15:03
UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

Kernel config: https://secure.tgbyte.de/dropbox/config-3.1.0-0301rc9-generic

Any ideas?

Thanks,
Thilo
