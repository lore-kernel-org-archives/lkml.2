Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2BMSaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:30:16 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:43713 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2BMSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:30:14 -0500
Message-ID: <4F3956B3.1060604@mikemestnik.net>
Date: Mon, 13 Feb 2012 12:30:11 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Sysreq during system hang where ssh/screen still accessible.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   I have an unusual hang:
The box is responding to monitor wakeup key presses and putting the 
display to sleep after idle, however the screen is always blank.

 From the network side a previously started root ssh screen session can 
create more views,but the shell never starts, neither does ls from an 
existing shell.

I've configured remote logging and there is noting in any of the logs to 
indicate a problem, smart-tools is installed.

The remote log(over SCTP) is still connected and the IRC client is still 
connected.

Kernel messages are being logged, last msg from apparmor about empathy.

Key presses wake up monitor, but sysreq-s is not logging anything.

No further ssh shells able to check, but I don't think that dmesg would 
even start.

However ssh/screen is still responsive to create new views and switch 
views, but the shell never starts.

Feb 12 17:33:33: The only error is smatd: Prefailure: Spin_Up_Time (3) 
changed to: 197
Feb 13 12:54 AM an email http://pastebin.com/A8srcY7v
However nothing in the _remote_ log around 1AM/12:54.

Any thoughts?
linux-image-3.2.0-15-generic-pae
System specs.
http://pastebin.com/35NwE0G1

