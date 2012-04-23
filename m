Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2DWWWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:22:40 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:59692 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F95C50C.4060203@redhat.com>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<4F95B17B.3030401@redhat.com>
	<CAE9FiQX52eL6ZFQ_X3uL5DukK03sPhByZpPh0++o6L=WF8BGXg@mail.gmail.com>
	<4F95C50C.4060203@redhat.com>
Date: Mon, 23 Apr 2012 15:22:35 -0700
X-Google-Sender-Auth: WGFKhd2-K0vbe6Wo-V58sIEZ2Ts
Message-ID: <CAE9FiQVAWqCYjy3tpvtnq6y4WMWRHoQFug-WsgUAtvjVpvkMqw@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 2:09 PM, Don Dutile <ddutile@redhat.com> wrote:
> even though I've tried every magic trick known with grub & kernel boot
> params.
> ... the PCI log btwn early boot and until the console is reconfigured is
> 'lost'

please change

earlycon=uart82550,io,0x1030,115200 earlyprintk=serial,ttyS0,115200
console=tty0 console=ttyS0,115200n8

===>

earlycon=uart82550,io,0x1030,115200


Yinghai
