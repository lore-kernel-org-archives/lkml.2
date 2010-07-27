Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0G0Vbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 17:31:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:37211 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab0G0Vbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 17:31:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Getting error message "Cannot read inode bitmap". Someone able to
 help?
Date: Tue, 27 Jul 2010 23:28:35 +0200
Message-ID: <i2nj7d$lpi$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd48739.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100721 SeaMonkey/2.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to restore data from a broken NAS device. This small box 
contained a embedded linux system and two 1TB hard drives.

After some tries, I managed to connect both drives via mdadm and was 
able to mount this raid as XFS.

Now I connected a brand new eSATA drive to this PC and started to copy 
the data (about 700 Gigabytes). Target disk was 1TB, so enough space to 
hold the source data.

With my first try (ext2 on target disk) I got the error "Cannot read 
inode bitmap". The kernel reported this error for the *target* device 
(the brand new SATA hard drive). I did a second try and reformated the 
target drive to ext3 and, again, I got the same error. So I installed 
"smartmontools" into my running live system and checked the drive. The 
new drive has no "reallocated sectors" but several read errors (about 500).

The worst thing about this is, that a diff between source and target 
showed many files differing, so I didn't just get errors, but I also 
have bad data on the target disk. This is a pretty *unstable* disc 
behaviour...

The copy program, I used, was "cp" from busybox.

What should I check to find the reason for this errors? Is it really 
possible that a brand new disc, which doesn't have conspicuous smart 
values, is the reason for this problem? May the eSATA disc enclosure 
(has a small circuit to also offer USB access) be the reason?

The log entries, I could get via dmesg, are available here:
http://pastebin.org/423211

Thank you very much in advance

Yours

Manuel Reimer

