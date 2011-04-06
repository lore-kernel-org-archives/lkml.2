Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1DFKv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:51:57 -0400
Received: from lo.gmane.org ([80.91.229.12]:50595 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1DFKv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:51:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: [2.6.39-rc2] perf top fails to mmap
Followup-To: gmane.linux.kernel
Date: Wed, 06 Apr 2011 12:51:40 +0200
Message-ID: <inhgjs$54a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 85-127-15-20.dynamic.xdsl-line.inode.at
User-Agent: KNode/4.4.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

when trying to profile a process with `perf top -p $PID', perf exits with:
Failed to mmap with 22 (Invalid argument)

this happens when running perf as the same process as the process and when 
running perf as root.

tim


