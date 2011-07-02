Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1GBHEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 03:04:55 -0400
Received: from lo.gmane.org ([80.91.229.12]:50068 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab1GBHEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 03:04:55 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Kernel panic with USB device
Date: Sat, 02 Jul 2011 09:04:49 +0200
Message-ID: <iumfu8$jmf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 0x4dd52733.adsl.cybercity.dk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've written about this before and it just happened again:

I have an AGK hard disk docking station, like this:

http://www.agknordic.com/index.php?side_id=387

Kernel is 2.6.38-gentoo-r6.

The problem is that on rare occasions, the machine crashes when I power the
device on. Like right now, Num lock and Caps lock blinking. There's nothing
in the log, other that a couple of lines of ^@. The machine didn't respond
to external ssh or pings.

>From now on, I'll try turning it on and then connecting its USB.

Thanks,
Niels

