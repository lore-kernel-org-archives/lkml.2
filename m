Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541Ab0HFQYJ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 6 Aug 2010 12:24:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755937Ab0HFQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:24:05 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX1/Q614JNF7Qx+yObLhpzOrKRmiFZHkf5d0h7ZpDBh
	3lSYDSVpS/HJq8
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: tomoyo-init (tomoyo-tools) results in kernel panic on kernel
 2.6.35-git2/3
To: linux-kernel@vger.kernel.org
Date: Fri, 06 Aug 2010 18:23:59 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.vg0yh9gtgp7xae@127.0.0.1>
User-Agent: Opera Mail/10.70 (Linux)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, i just compiled the 2.6.35-git3 kernel on my computer using debian 64  
bit as i did with all other kernels before.
Booting the git2/3 kernel results in a kernel panic because of  
/sbin/tomoyo-init.

No problem with the 2.6.35 kernel.

I've to remane /sbin/tomoyo-init to boot the kernel.
Now i purged tomoyo-tools version 2.2.0-20100225 (aptitude purge  
tomoyo-tool) and everything works ok.
Sorry, i forgot to backup the tomoyo-init script.

$ uname -a
Linux xxxxxx 2.6.35-git3 #4 SMP Fri Aug 6 15:22:08 CEST 2010 x86_64  
GNU/Linux


Karsten
