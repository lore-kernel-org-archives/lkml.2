Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0LAR0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:26:20 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:60414 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0LAR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:26:16 -0500
Message-ID: <4CF67D5F.3080609@csr.com>
Date: Wed, 01 Dec 2010 16:52:47 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>	 <20101201161039.GB29318@suse.de> <1291222151.1684.46.camel@leonhard>
In-Reply-To: <1291222151.1684.46.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Dec 2010 16:52:48.0355 (UTC) FILETIME=[2F299B30:01CB9178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim wrote:
> 2010-12-01 (수), 08:10 -0800, Greg KH:
>> On Wed, Dec 01, 2010 at 01:28:41PM +0900, Namhyung Kim wrote:
>>> Annotate whci_hcd_id_table as '__used' to fix following warning:
>>>
>>>   CC      drivers/usb/host/whci/hcd.o
>>> drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used
>> Are you seeing this warning when you build the module into the kernel,
>> or as a module?
>>
>> thanks,
>>
>> greg k-h
> 
> I saw it during allyesconfig build but not on allmodconfig.
> Maybe we can wrap it up in #ifdef CONFIG_MODULES ?

That might be best.  Can you do the same with drivers/uwb/whc-rc.c?  It
will have the same problem.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
