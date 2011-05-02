Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab1EBN5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:57:06 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:37576 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755206Ab1EBN5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:57:03 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc5-git2 boot crashs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 02 May 2011 09:56:59 -0400
Message-ID: <web-516522777@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A middle-big config (starting from Slackware huge-smp, or 
from a L.T. werner-config) works.  A more simple one, or a 
more bigger one, both don't work, but probably by 
different reasons.

A very basical config (starting from Slackware normal-smp) 
stops booting after 2 seconds; it don't find the root 
device (even if I told to it at the command line by the 
bios or dev name), and although the bootwait option, it 
crashs rather than simply wait.

An everythingyes config get several problems, reported 
here (and in my 2.6.39-rc3 reclamations).  Some of them 
are: crashs on zipping big files; secondary 
reset-resistent crashs wrongly understanding anything as 
ata device.

wl
---
Professional hosting for everyone - http://www.host.ru
