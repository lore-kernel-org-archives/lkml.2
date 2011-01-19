Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1ASPJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:09:34 -0500
Received: from mx4.wp.pl ([212.77.101.8]:35701 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1ASPJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:09:33 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 10:09:33 EST
Message-ID: <4D36FCFD.9030700@wp.pl>
Date: Wed, 19 Jan 2011 16:02:21 +0100
From: Bushman <buszu1@wp.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Bluetooth USB dongle dies often when using BT mouse.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [cROE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) The USB bluetooth dongle dies every few seconds/minutes when using BT 
mouse.

1.1) Table of contents:
1)     One line summary of the problem:
1.1)     This TOC
2)     Full description of the problem/report:
3)     Keywords (i.e., modules, networking, kernel):
4)     Kernel version (from /proc/version):
5)     Output of Oops.. message N/A?
6)    A small shell script or example program which triggers the problem N/A
7)     Environment
7.1)     Software
7.2)     Processor information (from /proc/cpuinfo):
7.3)     Module information (from /proc/modules):
7.4)     Loaded driver and hardware information (/proc/ioports, /proc/iomem)
7.5)     PCI information ('lspci -vvv' as root)
7.6)     SCSI information N/A
7.7)    Other information that might be relevant to the problem: dmesg 
output, usbmon debug output, lsusb

2) When i'm using bluetooth mouse my bluetooth dongle dies every few 
minutes taking the mouse down on the way. The dongle does not crash when 
idle, when using for file transfer or internet connectivity. I'm using 
"Blueman Device Manager 1.21" for configuring the mouse. The bluetooth 
dongle is branded "Manta" and the mouse is Esperanza model EM117. The 
mouse AND the bluetooth dongle were tested on other machines running 
various versions of Windows and Ubuntu 10.10. Under the Windows OS the 
problem does not exist. Under other Ubuntu OS the problems is exactly 
the same.

If that's not a problem, please include me to CC in replies to this 
problem since i'm not subscribing the mailing list and it is the only 
problem i'm dealing with at the moment. Thanks in advance.

3) Keywords: Bluetooth, USB, Mouse.

4) Kernel version: Linux version 2.6.32-27-generic (buildd@roseapple) 
(gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #49-Ubuntu SMP Wed Dec 1 
23:52:12 UTC 2010

5) Output of Oops:
N/A (Oops? o_O)

6) A small shell script or example program which triggers the problem
N/A

7) Enviroment: Acer Extensa 5200 running Ubuntu 10.04 LTS
Due to the large amount of information provided in this section it is 
available at http://www.bushman.pl/attachments/enviroment.txt

Regards,
Wojciech "Bushman" Nycz

PS: please add me to CC when replying to this email, thank you.
