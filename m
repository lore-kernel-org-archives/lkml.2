Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310Ab1EASHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:07:38 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:39259 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755062Ab1EASHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:07:37 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sun, 01 May 2011 14:07:33 -0400
Message-ID: <web-516277136@zbackend1.aha.ru>
In-Reply-To: <BANLkTimda-mi2rjgnX0jqg7Pg-J6HSDb6w@mail.gmail.com>
References: <web-516164730@zbackend1.aha.ru>
 <BANLkTimda-mi2rjgnX0jqg7Pg-J6HSDb6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, my kernel compiling / packaging / lilo.conf-writing 
script   always do this: it makes 3 manners for boot: 
 normal/grafics, text, initrd;  for this it makes an 
initrd too.  See below.  Normally this also works without 
any problem. This is necessary if someone want to make an 
installer. And just because of this, I compile plenty 
things inside vmlinuz , not as modules, because nowadays 
people have any kind of devices with touchpad, touchscreen 
etc.  And, last night, I tested all these boot methods, 
but in all attempts happened that error, that it didnt 
find the boot device, and then crashs, more strange 
because there also is a bootwait option in the command 
line (see below) (because nowadays people often have 
installed my distro on an usb key, or on an eee pc just 
the starter is on the internel flash chip, and the system 
with root fs is on an usb harddisk what takes time to be 
discovered).


But, now, the 2nd compilation, I made with the slackware 
huge configuration. And this works !! It boots normally, 
and it also don't crash  if unzipping big files.  So you 
were right, to use a more little config, for find out 
better the reason.   However, remember, at the end (until 
-rc20) also the everythingyes config should work, because 
this always was the case, and have to work because 
nowadays people have all kinds of computers, laptops, 
phones, coffe machines, washmachines etc etc running Linux 
and the distro kernel have to run ANYWAY on ANY DEVICE.


That successful slackware huge config is in the middle 
between the slackware smp config explained above which 
didnt boot, and between my normal everythingyes 
configuration which gave plenty problems.  So,  the 
differences to both sides can make it more easy to find 
out, a) why the slackware smp config didnt boot at all, 
not finding the root fs,    and to the other side, why b) 
my everythingyes config, which all the time worked (also 
on 2.6.34.8), give so many problems with 2.6.39-rcX.

Pls find, enclosed, as the 2nd file, the successful config 
which is still running on my computer and didnt crash yet 
(entering with slackware huge smp into menuconfig end 
going out without changes).  Also, as the 3rd file, is the 
difference of this to my everythingyes config used for 
-git2 to -git4; from tese differences it should be 
possible to find better what cause the many problems in 
the sense of comparison b) above.

However, I should mention, that this successful config has 
a problem with the grafics. On the laptop of my neighbour, 
it switched to a wrong text mode where the characters are 
little and 3 times on the top of the screen. And on my 
computer, I cannot change to the text screen with 
CTRL-ALT-F1 etc.


wl



---
Professional hosting for everyone - http://www.host.ru
