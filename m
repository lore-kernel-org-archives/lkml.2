Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1DZKYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:24:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:57952 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1DZKYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:24:50 -0400
Message-ID: <4DB69D6B.9060106@linutronix.de>
Date: Tue, 26 Apr 2011 12:24:43 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: merge the two dummy_hcds into one
References: <20110414114605.GA17871@linutronix.de> <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org> <003501cc03d9$d3989300$7ac9b900$@org>
In-Reply-To: <003501cc03d9$d3989300$7ac9b900$@org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya Brokhman wrote:
>> This will means creating only one host-side platform device, and then
>> creating two usb_hcd structures below it.  Tanya's design should be
>> based on Sarah's work.
>>
> 
> Hi Alan

Hi Tanya,

> Thank you for your inputs. I'm not familiar with Sarah's work you mentioned.
> I'll have to look into that. Could you please point me to where I can find
> this code? Has it been merged into linux-next yet or just posted on the
> mailing list?

Please take a look at xhci_pci_probe() where usb_create_shared_hcd() is
used. It was introduced by

commit f6ff0ac878eb420011fa2448851dd48c3a7e7b31
Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date:   Thu Dec 16 11:21:10 2010 -0800

     xhci: Register second xHCI roothub.

in v2.6.39-rc1.

Sebastian
