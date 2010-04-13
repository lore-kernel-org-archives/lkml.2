Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab0DMMWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:22:05 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42192 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0DMMWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:22:02 -0400
Message-ID: <4BC461AD.6090504@monstr.eu>
Date: Tue, 13 Apr 2010 14:21:01 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>
CC: John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stefan Asserhall <stefan.asserhall@xilinx.com>,
       Goran Bilski <goran@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
       Grant Likely <grant.likely@secretlab.ca>, sam@ravnborg.org,
       "Steven J. Magnani" <steve@digidescorp.com>, stephenn@xilinx.com,
       Karen Whelan <karen.whelan@petalogix.com>,
       Wendy Liang <wendy.liang@petalogix.com>
Subject: Microblaze - The fist year
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux community,

The MicroBlaze Linux Kernel has been in mainline for exactly one year. 
It is time to look back and celebrate this year.

First of all I would like to thank Xilinx and PetaLogix for their 
committed support and everybody who has helped to improve the MicroBlaze 
Linux kernel namely to Andrew Morton, Arnd Bergmann, Edgar E. Iglesias, 
Grant Likely, Ingo Molnar, John Linn, John Williams, Linus Torvalds, Sam 
Ravnborg, Stephen Neuendorffer and Steve Magnani. Goran Bilski and 
Stefan Asserhall (from Xilinx Processing Solutions group) have provided 
valuable assistance too.

Thank you for your work.

MicroBlaze is the first soft-cpu to be merged to the mainline Linux 
kernel and I believe it has proved to be an effective decision to do so. 
With the support of Xilinx and PetaLogix we have dedicated a lot of time 
to improve the MicroBlaze Linux port, adding new features and 
stabilizing the whole kernel. There are still areas for improvement but 
we have set a good direction and we hope with continued support from 
Xilinx and PetaLogix to achieve much more in the future


I would like to ask the whole community if you can point us to new 
features (or weak places) which should be implemented on MicroBlaze. 
Thank you for your continued input.


Let me summarize some MicroBlaze Linux highlights over the last 12 months.

MicroBlaze noMMU - added on April 13, 2009
MicroBlaze QEMU support - April, 2009
MicroBlaze MMU - added on June 12, 2009
First youtube movie with MicroBlaze QEMU by PetaLogix - October 28, 2009
Ftrace support - November 2009
Everyday testing framework - December 2009
and many others

Latest code is available on PetaLogix GIT server.
http://developer.petalogix.com/git/gitweb.cgi (or 
http://git.monstr.eu/git/gitweb.cgi)

Output log from everyday testing
http://www.monstr.eu/wiki/doku.php?id=log:log

I also created a new facebook fan page for MicroBlaze where you can join 
us. http://www.facebook.com/pages/Microblaze-linux/111131818899940

As I announced on Facebook, I decided to open monstr.eu wiki which is 
becoming the microblaze linux wiki.
You can register on 
http://www.monstr.eu/wiki/doku.php?id=user:user&do=register

Thank you.

Best regards,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
