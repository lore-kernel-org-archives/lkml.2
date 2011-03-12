Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1CLUtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:49:22 -0500
Received: from borg.medozas.de ([188.40.89.202]:36497 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab1CLUtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:49:21 -0500
Date: Sat, 12 Mar 2011 21:49:19 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: x86@kernel.org
Subject: MCE hardware error, but no message
Message-ID: <alpine.LNX.2.01.1103122136220.20070@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Running Linux 2.6.37, I am getting these errors on one of a box:

[696782.810387] [Hardware Error]: No human readable MCE decoding support 
on this CPU type.
[696782.810470] [Hardware Error]: Run the message through 'mcelog 
--ascii' to decode.
[696783.585853] [Hardware Error]: No human readable MCE decoding support 
on this CPU type.
[696783.585937] [Hardware Error]: Run the message through 'mcelog 
--ascii' to decode.

Except that it never tells me the actual non-human readable form.
The error starts to show after 6-48 hours after a reboot (including 
warm reboots). A second machine of the exact same configuration shows no 
problems over the past 30 days. Environmental sensors of the problem box 
show normal parameters.

How would I get the messages to run through mcelog?
