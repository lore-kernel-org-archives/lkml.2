Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab2HWPeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:34:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61866 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab2HWPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:33:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,300,1344211200"; 
   d="scan'208";a="14150754"
Message-ID: <50364A30.2040008@citrix.com>
Date: Thu, 23 Aug 2012 16:20:16 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "x86@kernel.org" <x86@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208212315330.2856@ionos> <20120822135753.GA30964@phenom.dumpdata.com> <alpine.LFD.2.02.1208221618380.2856@ionos> <5034F0FD.8040902@citrix.com> <5035F7BD.6090205@citrix.com> <alpine.LFD.2.02.1208231714450.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208231714450.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/12 16:15, Thomas Gleixner wrote:
> On Thu, 23 Aug 2012, Attilio Rao wrote:
>    
>> On 22/08/12 15:47, Attilio Rao wrote:
>>      
>>> but I would like to repost the patch serie skipping the referral to
>>> PVOPS in the commit logs, I will do so right now, so please wait for
>>> another patch serie.
>>>
>>>        
>> For your convenience:
>> http://lkml.org/lkml/2012/8/22/450
>>      
> Not very convenient. I really prefer e-mail :)
>    

Actually you are in the "to" line for that patch serie.
Can you see the e-mail?

Attilio
