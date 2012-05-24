Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2EXFQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:16:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10308 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2EXFQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:16:10 -0400
X-IronPort-AV: E=Sophos;i="4.75,649,1330876800"; 
   d="scan'208";a="5026761"
Message-ID: <4FBDC4F4.4000404@cn.fujitsu.com>
Date: Thu, 24 May 2012 13:19:48 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: add max_addr boot option
References: <4FBB3A23.50102@cn.fujitsu.com> <CAErSpo4cUwwJNq45GZhUW02FU+T72OmvGfNcd2d1WhFo86KFOw@mail.gmail.com>
In-Reply-To: <CAErSpo4cUwwJNq45GZhUW02FU+T72OmvGfNcd2d1WhFo86KFOw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/24 13:14:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/24 13:14:36,
	Serialize complete at 2012/05/24 13:14:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 05/23/2012 10:25 PM, Bjorn Helgaas Wrote:
> On Tue, May 22, 2012 at 1:02 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> +       if (start >= max_addr) {
>> +               printk(KERN_INFO "Ingoring memory: %016Lx - %016Lx\n",
>> +                      (unsigned long long)start,
>> +                      (unsigned long long)(start + size));
>> +               return;
>> +       }
>> +
>> +       if (max_addr - start < size) {
>> +               printk(KERN_INFO "Ingoring memory: %016Lx - %016Lx\n",
>> +                      (unsigned long long)max_addr,
>> +                      (unsigned long long)(start + size));
>> +               size = max_addr - start;
> 
> s/Ingoring/Ignoring/
> 
> Please use a format like "e820: ignoring [mem %#010Lx-%#010Lx]" so it
> matches other places where we print physical address ranges.  See
> https://lkml.org/lkml/2012/2/13/436

Hmm, no one reviews/acks patch. So I am not sure whether we need to do this.
So I think there is no need to use such format now.

Thanks
Wen Congyang
> 
> Bjorn
> 

