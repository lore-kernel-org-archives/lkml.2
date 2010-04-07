Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0DGBKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:10:34 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:21924 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab0DGBK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:10:28 -0400
Message-ID: <4BBBDAF4.4020304@oracle.com>
Date: Tue, 06 Apr 2010 18:08:04 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed
 (0xffffffff)
References: <20100406225425.GA8292@hexapodia.org>
In-Reply-To: <20100406225425.GA8292@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BBBDB74.00A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 03:54 PM, Andy Isaacson wrote:
> This Dell Precision WorkStation T3400 doesn't boot 2.6.34-rc1 (tried
> 522dba71).  2.6.33 was fine, and it's been running various stable
> kernels for the last 18 months.  Unfortunately I can't reasonably bisect
> as I need this machine to be usable, but I can test specific patches or
> options.  (three or four reboots is fine, 15 is not.)
> 
> full dmesg from failing boot and a successful boot at
> http://web.hexapodia.org/~adi/tmp/20100406-pci-ahci-reset-fail/
> 
> I suspect it's due to:
> 
> [    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> [    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]
> 
> so I've CCed a few recent committers to setup-res.c.
> 

can you try to boot with pci=nocrs ?

also please check with -rc4.

YH

