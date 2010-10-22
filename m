Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0JVJka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:40:30 -0400
Received: from rrzmta5.rz.uni-regensburg.de ([194.94.155.56]:55941 "EHLO
	rrzmta5.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab0JVJk2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:40:28 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 05:40:28 EDT
Message-Id: <4CC176BC020000A10001090A@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 22 Oct 2010 11:34:20 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Note: complete kernel freeze triggered by xenmon.py in SLES10
 SP3 x86_64
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
(Kids, don't do this)

When I tried "xenmon.py" on a two dual-core Operon machine running SLES10 SP3 x86_64 in XEN#s Dom0, the machine froze (i.e. Dom0, all DomUs). Today with all current updates, the same happened again. After booting and fsck (reiserfs), I found no messages in syslog or XEN's logs. When the machine seemed frozen, the console did not react to key presses (screen was black).

# rpm -q kernel-xen xen
kernel-xen-2.6.16.60-0.69.1
xen-3.2.3_17040_20-0.4.2

Regards,
Ulrich


