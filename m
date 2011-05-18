Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1ERPIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:08:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44478 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab1ERPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:08:10 -0400
Date: Wed, 18 May 2011 11:06:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: Vasiliy G Tolstov <v.tolstov@selfip.ru>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [Xen-devel] Re: [PATCH V3] xen/balloon: Memory hotplug support
 for Xen balloon driver
Message-ID: <20110518150630.GA4709@dumpdata.com>
References: <20110517214421.GD30232@router-fw-old.local.net-space.pl>
 <1305701868.28175.1.camel@vase>
 <1305703309.7738.23.camel@dagon.hellion.org.uk>
 <1305703494.28175.2.camel@vase>
 <20110518103543.GA5066@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518103543.GA5066@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DD3E088.0063:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is proper udev rule:
> 
> SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"
> 
> Konrad, could you add it to git comment and Kconfig help ???

I am going to be lazy and ask you to resend this patch with that udev rule mentioned in it :-)
