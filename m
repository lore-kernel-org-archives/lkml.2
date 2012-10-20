Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2JTU57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 16:57:59 -0400
Received: from smtprelay0213.b.hostedemail.com ([64.98.42.213]:55376 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751577Ab2JTU55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 16:57:57 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1961
Date: Sat, 20 Oct 2012 20:57:56 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bp@alien8.de
Cc: linux-kernel@vger.kernel.org
Message-ID: <588652744.31008.1350766676335.JavaMail.mail@webmail19>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020180437.GA9301@liondog.tnic>
Subject: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.196.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 21, 2012, Borislav Petkov wrote: 

> Ok, here's what you can try:
> 
> * You say this happens with google chrome. Does it happen if you use
> another browser: firefox, etc?
> 
> * Can you build a 64-bit kernel and try the same with it? The 32-bit
> userspace should work in compat mode just fine.
> 
> * Can you run memtest on your machine and check whether your DIMMs
> aren't generating ECC errors? Are your DIMMs ECC, btw?
> ...


I can reproduce this problem in a virtual machine, which means I have found a real
kernel or GCC bug. Alas, VirtualBox 4.2.2 hangs entirely when I run this virtual machine -
I've never seen anything like that. Windows 7 64 bit which hosts this VirtualBox cannot
even kill a VirtualBox instance.

Unfortunately even though I run the kernel with "console=ttyS0,115200 console=tty0"
parameters they don't help - I see no panic messages on a "virtual" serial port, which
looks like we've got a very deep freeze.

