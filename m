Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1G3KBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 06:01:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38818 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1G3KBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 06:01:46 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: pxa: brief description 
Date: Sat, 30 Jul 2011 12:01:25 +0200
Message-Id: <1312020086-26328-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a problem with a pxa270-based custom board when using the UART on
high speed (921.6 kbit/s).
The symptom was that the whole system just hangs sporadically.

After this work around was implemented the system seems to behave good.

In fact, I don't really see why the system should hang since there is a 
max counter, so the loop cannot run forever.

The patch is tested on kernel version 2.6.32, but the driver is allmost
the same.

Please take a look.
Feedback is very much appreciated

