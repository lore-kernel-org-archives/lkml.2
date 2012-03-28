Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2C1Cwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:52:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53512 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2C1Cwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:52:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q2S2qP8c009362
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1332834834-5185-1-git-send-email-hayeswang@realtek.com> <1332834834-5185-5-git-send-email-hayeswang@realtek.com> <20120327225453.GD22177@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 5/5] r8169: support RTL8411
Date: Wed, 28 Mar 2012 10:52:24 +0800
Message-ID: <97E69EF42D4742BA8789F8EAAA3A4AF8@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac0MbP6Rln4lNndhTwq2o8Yq+cPsvAAH12LQ
In-Reply-To: <20120327225453.GD22177@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> > @@ -250,6 +252,9 @@ static const struct {
> >  							
> JUMBO_9K, false),
> >  	[RTL_GIGA_MAC_VER_37] =
> >  		_R("RTL8402",		RTL_TD_1, FIRMWARE_8402_1,
> > +							JUMBO_1K, true),
> > +	[RTL_GIGA_MAC_VER_38] =
> > +		_R("RTL8411",		RTL_TD_1, FIRMWARE_8411_1,
> >  							JUMBO_1K, true)
> 
> Realtek's product page documents this chipset as a gigabit 
> one. It seems
> strange to configure it as a jumbo packet unable one.
> 

It is my mistake. I would fix it.

[...]
> "The RTL8411 supports Receive Side Scaling (RSS) to hash incoming TCP
> connections and load-balance received data processing across 
> multiple CPUs.
> RSS improves the number of transactions per second and number 
> of connections
> per second, for increased network throughput. Header Data 
> Split (HDS) support
> enables faster processing of TCP/IP networking protocols for 
> improved network
> performance.
> 
> Virtual Machine Queue (VMQ) is a hardware virtualization 
> technology for the
> efficient transfer of network traffic to a virtualized host 
> OS. VMQ uses
> hardware packets filtering to deliver packet data from an 
> external virtual
> machine network directly to virtual machines, which reduces 
> the overhead of
> routing packets and copying them from the management 
> operating system to the
> virtual machine.
> 
> Note: RTL8411 Virtual Machine Queue (VMQ) is only functional 
> in computers
> running Windows Server 2008 R2 with the Hyper-V server role 
> installed."
> 
> Will Realtek consider helping make those being available on Linux ?
> 

I don't have the documents about these. I need more information from the other
engineers, and I have to discuss with my leader. Maybe I could research the
possibility when I have more time.
 
Best Regards,
Hayes

