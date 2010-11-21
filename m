Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0KUPRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:17:40 -0500
Received: from lo.gmane.org ([80.91.229.12]:35160 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab0KUPRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:17:39 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: killing SCHED_FIFO tasks in 2.6.37-rc2+
Followup-To: gmane.linux.kernel
Date: Sun, 21 Nov 2010 16:17:16 +0100
Message-ID: <icbd5t$c1i$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 85-127-14-175.dynamic.xdsl-line.inode.at
User-Agent: KNode/4.4.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

testing 2.6.37-rc2+, i found that i cannot kill any task, which is running with 
SCHED_FIFO using kill (-9) or killall (-9). is this a known issue?

thanks, tim

-- 
tim@klingt.org
http://tim.klingt.org

It is better to make a piece of music than to perform one, better to
perform one than to listen to one, better to listen to one than to
misuse it as a means of distraction, entertainment, or acquisition of
'culture'.
  John Cage


