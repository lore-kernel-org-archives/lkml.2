Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab2C2Pzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759504Ab2C2Pzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:55:45 -0400
Date: Thu, 29 Mar 2012 11:55:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: lockups shortly after booting in current git.
Message-ID: <20120329155542.GA31285@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.3-8839-gb5174fa I see some behaviour on my laptop
that I haven't noticed on other machines.
It boots up, I can log in, and start up a terminal, firefox, banshee
and use the system, and all is good. Then if I lock the screen,
walk away for a while and come back to it, the loadavg has sky-rocketed,
and every process is hung. Trying to run any commands that perform disk io
hang immediately.

There's a (truncated) sysrq-t output at http://codemonkey.org.uk/junk/process-trace.txt

Top showed kworker was going nuts. Trying to run perf resulted in a black screen.

anyone have any ideas ?

	Dave

