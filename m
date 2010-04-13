Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0DMTEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:04:35 -0400
Received: from capside.net ([81.19.98.74]:41632 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab0DMTEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:04:33 -0400
Message-ID: <4BC4BFFD.9040802@sysvalve.es>
Date: Tue, 13 Apr 2010 21:03:25 +0200
From: =?ISO-8859-1?Q?=22L=2E_Alberto_Gim=E9nez=22?= 
	<agimenez@sysvalve.es>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
       gregkh@suse.de, jonas.sjoquist@ericsson.com, steve.glendinning@smsc.com,
       torgny.johansson@gmail.com, dbrownell@users.sourceforge.net,
       omar.oberthur@gmail.com, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH Resubmission] drivers/net/usb: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>	<1270678281-20750-1-git-send-email-agimenez@sysvalve.es> <20100413.011540.115903049.davem@davemloft.net>
In-Reply-To: <20100413.011540.115903049.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Unless you add a rule to drivers/net/Makefile, the build won't
> actually get to your driver unless one of the other USB networking
> devices are configured.
>   

Hi David,

Thanks for the info. I didn't know that I had to add an entry on the 
upper level Makefile. I guess that something like 
obj-$(CONFIG_USB_IPHETH) += usb/ should be enough? (I got it from the 
other USB net drivers).

I won't be able to work on it today, I've been very busy today and can't 
look into this, but I've not given up :)

> Please fix this up and resubmit. 

I have also in my queue a patch sent from upstream to fix the latest 
issues pointed out by Roland Dreier, and I need to test it a little bit 
more.

Thanks for your comments and patience!


Best regards,
L. Alberto Giménez
