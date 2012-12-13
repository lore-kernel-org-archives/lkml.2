Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2LMEWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:22:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58120 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2LMEWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:22:09 -0500
Date: Wed, 12 Dec 2012 20:24:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 02/11] drivers/base: Add hotplug framework code
Message-ID: <20121213042437.GA14240@kroah.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
 <1355354243-18657-3-git-send-email-toshi.kani@hp.com>
 <20121212235418.GB22764@kroah.com>
 <1355371365.18964.89.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355371365.18964.89.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 09:02:45PM -0700, Toshi Kani wrote:
> On Wed, 2012-12-12 at 15:54 -0800, Greg KH wrote:
> > On Wed, Dec 12, 2012 at 04:17:14PM -0700, Toshi Kani wrote:
> > > Added hotplug.c, which is the hotplug framework code.
> > 
> > Again, better naming please.
> 
> Yes, I will change it to be more specific, something like
> "sys_hotplug.c".

Ugh, what's wrong with just a simple "system_bus.c" or something like
that, and then put all of the needed system bus logic in there and tie
the cpus and other sysdev code into that?

thanks,

greg k-h
