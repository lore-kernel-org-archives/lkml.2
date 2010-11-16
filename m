Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab0KPNS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:18:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0KPNS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:18:56 -0500
Message-ID: <4CE284C7.4040209@vlnb.net>
Date: Tue, 16 Nov 2010 16:19:03 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Bart Van Assche <bvanassche@acm.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
References: <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com> <20101115184422.GA9566@kroah.com> <4CE19A94.8080504@vlnb.net> <20101115221359.GA9530@kroah.com>
In-Reply-To: <20101115221359.GA9530@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:NyF5FQ/7aJDkPU+s5uHpKAQ+mkKX9OITZeI7r2gbaOP
 K9Z4n5fd1xmCDs/U7+EubOnFRxFCPY6JStR3o3FPvbdZMgjCMQ
 T9tf7LKZroAQFZeBJUyij/6TG7NdbLiiyccnRSPTg2lbNCUEm+
 XSS10WpCwWl1Zh03VzUtv1FhYoaphGldUmiKt7icfi5CbiGod/
 GGjJAdBZ8Ft4qCUFpY+Yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH, on 11/16/2010 01:13 AM wrote:
>>> Please use 'struct device', it is what you want to do here.
>>
>> But we don't have any device to show up in the global device tree!
> 
> Not true at all.

Why?

Greg, sorry, you keep writing as if we all are idiots, but keep refusing
to explain us, idiots, why we can't do what we did. It isn't very
constructive, is it?

>> We don't have any devices in the struct device's understanding at all!
> 
> Then create them just like you are doing so for your kobject use.
> 
> The first device would be the root one, and then everything trickles
> down from there.

Sorry, I can't understand what you mean. What would be the purpose of
this configuration and what benefits it would bring?

Anyway, let's forget about SCSI. Do you believe that struct device
should be created for all IP addresses on which an NFS server listen and
for all exports it exports?

> And use configfs for your configuration stuff, that's what it is there
> for, and if it doesn't somehow work properly for you, please work with
> the configfs developers to fix that up.

I explained why it isn't a too good option in another e-mail.

Thanks,
Vlad
