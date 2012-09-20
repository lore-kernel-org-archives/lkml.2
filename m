Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2ITTCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:02:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61039 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab2ITTCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <505B5C11.1050503@asyr.hopto.org>
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com>
 <505B5C11.1050503@asyr.hopto.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Sep 2012 13:02:15 -0600
Message-ID: <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
To: Thanasis <thanasis@asyr.hopto.org>
Cc: LKML <linux-kernel@vger.kernel.org>, nic_swsd@realtek.com,
        Francois Romieu <romieu@fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 12:10 PM, Thanasis <thanasis@asyr.hopto.org> wrote:
> on 09/20/2012 08:47 PM Bjorn Helgaas wrote the following:
>> On Thu, Sep 20, 2012 at 11:28 AM, Thanasis <thanasis@asyr.hopto.org> wrote:
>>> I have an Acer Aspire One notebook, and it has a NIC as shown below:
>>>
>>> # lspci |grep -i Realtek
>>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>>> RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
>>>
>>> The driver module that I use is r8169. It works with 2.6 series of
>>> kernels, but it does *not* with the recent 3.x of kernels.
>>> Question: Should I stick with 2.6 kernels, or are there any directions
>>> on how to make the NIC work with recent 3.x kernels?
>>
>> Can you collect the complete dmesg logs from both 2.6.38 and the 3.x
>> kernel?  This should just work, so maybe something got broken.
>
> Attached are the dmesg outputs from 2.6.38 and 3.5.4 kernels (file
> dmesg.tar.bz2)

Thanks.  I don't see anything wrong from the PCI core point of view.
But searching for "r8169 transmit queue timed out" found lots of
similar reports.

+cc 8169 driver folks
