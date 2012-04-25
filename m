Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2DYC71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab2DYC7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:59:25 -0400
Message-ID: <4F976889.3010809@redhat.com>
Date: Tue, 24 Apr 2012 22:59:21 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
References: <20120410090306.GA7056@richard>	<20120422155202.GA13540@richard>	<4F95B17B.3030401@redhat.com>	<CAE9FiQX52eL6ZFQ_X3uL5DukK03sPhByZpPh0++o6L=WF8BGXg@mail.gmail.com>	<4F95C50C.4060203@redhat.com> <CAE9FiQVAWqCYjy3tpvtnq6y4WMWRHoQFug-WsgUAtvjVpvkMqw@mail.gmail.com>
In-Reply-To: <CAE9FiQVAWqCYjy3tpvtnq6y4WMWRHoQFug-WsgUAtvjVpvkMqw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:22 PM, Yinghai Lu wrote:
> On Mon, Apr 23, 2012 at 2:09 PM, Don Dutile<ddutile@redhat.com>  wrote:
>> even though I've tried every magic trick known with grub&  kernel boot
>> params.
>> ... the PCI log btwn early boot and until the console is reconfigured is
>> 'lost'
>
> please change
>
> earlycon=uart82550,io,0x1030,115200 earlyprintk=serial,ttyS0,115200
> console=tty0 console=ttyS0,115200n8
>
> ===>
>
> earlycon=uart82550,io,0x1030,115200
>
>
> Yinghai
I'm pretty sure I tried that, and only added the earlyprintk
and console args when the earlycon didn't work, but I'll give it another try...



