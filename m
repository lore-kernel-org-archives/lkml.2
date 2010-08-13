Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264Ab0HMAs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:48:26 -0400
Received: from claw.goop.org ([74.207.240.146]:46009 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761256Ab0HMAsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:48:23 -0400
Message-ID: <4C649655.8070009@goop.org>
Date: Thu, 12 Aug 2010 17:48:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Daniel Kiper <dkiper@net-space.pl>
CC: xen-devel@lists.xensource.com, stefano.stabellini@eu.citrix.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        v.tolstov@selfip.ru, linux-mm@kvack.org
Subject: Re: [Xen-devel] Re: [PATCH] GSoC 2010 - Memory hotplug support for
 Xen guests - third fully working version
References: <20100812012224.GA16479@router-fw-old.local.net-space.pl> <4C6495DC.4030005@goop.org>
In-Reply-To: <4C6495DC.4030005@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/12/2010 05:46 PM, Jeremy Fitzhardinge wrote:
>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig index 
>> fad3df2..4f35eaf 100644 --- a/drivers/xen/Kconfig +++ 
>> b/drivers/xen/Kconfig @@ -9,6 +9,16 @@ config XEN_BALLOON the system 
>> to expand the domain's memory allocation, or alternatively return 
>> unneeded memory to the system. +config XEN_BALLOON_MEMORY_HOTPLUG + 
>> bool "Xen memory balloon driver with memory hotplug support" + 
>> default n + depends on XEN_BALLOON && MEMORY_HOTPLUG + help + Xen 
>> memory balloon driver with memory hotplug support allows expanding + 
>> memory available for the system above limit declared at system 
>> startup. + It is very useful on critical systems which require long 
>> run without + rebooting. + config XEN_SCRUB_PAGES bool "Scrub pages 
>> before returning them to system" depends on XEN_BALLOON diff --git 
>> a/drivers/xen/balloon.c b/drivers/xen/balloon.c index 

Gah, what a mess.  Will repost later.

     J
