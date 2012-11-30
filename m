Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030731Ab2K3P3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:29:54 -0500
Received: from mxout2.netvision.net.il ([194.90.9.21]:48840 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030716Ab2K3P3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:29:53 -0500
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 10:29:53 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50B8D069.8070608@gmail.com>
Date: Fri, 30 Nov 2012 17:27:37 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354287112-18159-1-git-send-email-eli.billauer@gmail.com>
 <1354287112-18159-2-git-send-email-eli.billauer@gmail.com>
 <20121130150944.GB2658@kroah.com>
In-reply-to: <20121130150944.GB2658@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made changes in the code as a response to almost all your comments to 
my best understanding.

I also sent a separate mail responding to a couple of issues, which 
seems not have reached you.

But to put it short:

* The pci_ids: I wasn't sure if I should remove only my own product ID 
or all the vendor IDs, and this is clear now.

* As for the documentation, I don't quite understand what I should add. 
There's a rather extensive documentation for download at the site. The 
docs for the host side mostly instruct common UNIX programming 
techniques: The device files are just data pipes to FIFOs in the FPGA, 
behaving like one would expect.

* As for the special class issue: When Xillybus is used, the whole 
system's mission is usually around it (e.g. it's a computer doing data 
acquisition through the Xillybus pipes). So giving it a high profile 
makes sense, I believe. Besides, a dozen of device files are not rare. 
Needless to say, I'm not going to insist on this.

Other than that, it's all changes in the code. It's a major change there.

Sorry for this miscommunication.

   Eli



On 11/30/2012 05:09 PM, Greg KH wrote:
> You didn't answer my previous comments about the kernel/user interface
> here, why not?
>
> And you ignored my other review comments, which is a sure way for me to
> want to reject this and not look at any future submissions from you for
> at least a month...
>
>    


