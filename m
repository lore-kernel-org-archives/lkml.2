Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2DYJK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:10:59 -0400
Received: from mail-qa0-f56.google.com ([209.85.216.56]:44832 "EHLO
	mail-qa0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab2DYJK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:10:58 -0400
X-Greylist: delayed 2154 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 05:10:58 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Wed, 25 Apr 2012 01:35:03 -0700 (PDT)
In-Reply-To: <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=80.79.80.249; posting-account=QHeL1goAAACOxKFIX_qcWBFQ-yrvkYkM
NNTP-Posting-Host: 80.79.80.249
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no> <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 80.79.80.249
MIME-Version: 1.0
Message-ID: <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
Subject: Re: Unhandled IRQs on AMD E-450
From: andymatei@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: Clemens Ladisch <clemens@ladisch.de>, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, "Nguyen, Dong" <Dong.Nguyen@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am not that good in Linux as you guys are but here it goes. I have bought the Asus E45M1-M PRO to use in my home storage. I had 2 PCI Intel NICs that i wanted to use for iSCSI traffic that goes to 2 ESXi servers. 4 Seagate@2TB and one WD for  OS. I use Openfiler as a storage appliance. Problem appears after 20-30 minutes after starting the PC. I get "Disabling IRQ 16" and "Disabling IRQ 19". SATA disks drop from 130MB/s to 2MB/s speed, web interface does not work anymore. After reboot everything works but goes down again after 30 minutes. Is there a patch or something that resolves this issue yet?

Thanks,
Andrei
