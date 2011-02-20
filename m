Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1BTBvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:51:01 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49251 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1BTBvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=fQrvUNbr7SWWVUT2x4wL4IVmImcdiMUd+0WSmGBAtRA2qH3E8/u7Vj5O+Re+VEafeh
         CMoVLwesMcp0FiG+BXhG1W+J7zTG58WqBf/lwl+mRcWr/mnqkXTU7lPJhZhSrT5goWwh
         D4jiRlxT7bqW9XKT/FMDtaTUQHLZ2qDDQ5Xi0=
MIME-Version: 1.0
Date: Sat, 19 Feb 2011 20:43:02 -0500
Message-ID: <AANLkTi=5HJVW-nx34rFaXG6O_rC=QfiFD9muES-rKz=X@mail.gmail.com>
Subject: Thunar generating kernel oops on Slackware64 machine
From: Louis-Philippe Allard <lp.allard.1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!  (Please accept my apologies, I tried to send the following
email several times as html message and did not realize your server
considers html emails as potential smap and therefore rejects them)...

I have initially asked the LinuxQuestions.org community about this
issue, and have been recommended to look at the oops-tracing.txt of
the Kernel documentation.  This is why I am sending you this email.
On a machine running Slackware64 13.1 with kernel compiled and
installed from sources 2.6.37 stable, I am using XFCE as the DE.  I
noticed whenever I launch Thunar and expand the folder tree on the
left pane, thunar freeze (seems to search for something as I can still
click the other folders/locations) but the window is empty and the
cursor is "busy".
I need to kill thunar in order to exit.

I also noticed this output in the terminal when this happens (it
always happens):

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Oops: 0002 [#1] PREEMPT SMP

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Oops: 0002 [#1] PREEMPT SMP

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Stack:

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Stack:

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Call Trace:

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Call Trace:

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Code: f3 90 e9 7c ff ff ff 4c 8d 73 04 4c 8d 7b 08 4c 89
f7 e8 16 0f 00 00 48 8b 43 10 48 8d 55 b0 4c 89 7d b0 48 89 53 10 48
89 45 b8 <48> 89 10 83 ca ff 4c 89 65 c0 89 d0 87 03 ff c8 0f 84 88 00
00

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: Code: f3 90 e9 7c ff ff ff 4c 8d 73 04 4c 8d 7b 08 4c 89
f7 e8 16 0f 00 00 48 8b 43 10 48 8d 55 b0 4c 89 7d b0 48 89 53 10 48
89 45 b8 <48> 89 10 83 ca ff 4c 89 65 c0 89 d0 87 03 ff c8 0f 84 88 00
00

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: CR2: 0000000000000000

Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
htpc kernel: CR2: 0000000000000000

I would appreciate some guidance.  If you need anything more, please
do not hesitate to ask!
Thanks!
