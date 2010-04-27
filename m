Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0D0Seq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:34:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50963 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0D0Sep (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Apr 2010 14:34:45 -0400
Date: Tue, 27 Apr 2010 14:34:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
Message-ID: <20100427183428.GA15385@phenom.dumpdata.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD71A2D.6050309@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BD72E40.0089:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Can you provide a short example of test scenario? As in what I should do
>> to reproduce this problem?
>>    
>
> Take the latest upstream (well ... to be honest, a bit older than that  
> because of some other bugs) -- take 2.6.33 and try to boot it as a PV  

2.6.34-rc5 PV boots under Xen for me (and pretty much since 2.6.33 +
Suresh fix for the CONFIG_RODATA_MARK).

Perhaps I am missing some of the .config options you have set that make it not work?

The irqbalance daemon looks to be running - but I think you are hitting
this during bootup?  How long do you have to wait for this to trigger?

How many CPUs did you assign to your guest?

What are the "other bugs" you speak off?

> guest.  I'm using a RHEL5 Xen HV fwiw ...

OK, so your control domain is RHEL5. Mine is the Jeremy's xen/next one
(2.6.32). Let me try to compile RHEL5 under FC11 - any tricks necessary
to do that?
