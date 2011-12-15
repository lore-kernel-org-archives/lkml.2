Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab1LOQXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:23:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:37477 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052Ab1LOQW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:22:59 -0500
Message-ID: <4EEA1EDD.9000609@linutronix.de>
Date: Thu, 15 Dec 2011 17:22:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Clemens Ladisch <clemens@ladisch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix number of mapped SG DMA entries
References: <Pine.LNX.4.44L0.1112151058090.1644-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112151058090.1644-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 05:01 PM, Alan Stern wrote:

>> Is there anything special you do to get into this kind of situation?
>> Like 16GiB of memory on 32bit with highmem and a brutal disk/io test
>> case so?
>
> As I understand it, the typical case is that two SG entries in a row
> refer to adjacent pages of physical memory.  The mapping routine then
> collapses them into a single entry referring to all the pages.
>
> However, this is not the sort of thing you can deliberately cause,
> unless you set up your SG list by hand.

Thanks, both of you for the explanation.

>
> Alan Stern

Sebastian
