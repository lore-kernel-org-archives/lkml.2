Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1ADOfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:35:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:62837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1ADOfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:35:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,272,1291622400"; 
   d="scan'208";a="874301775"
Message-ID: <4D233039.8010509@intel.com>
Date: Tue, 04 Jan 2011 22:35:37 +0800
From: "Zhai, Edwin" <edwin.zhai@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] increase ple_gap default to 64
References: <20110103101907.2926ecca@annuminas.surriel.com>	<4D229221.8070305@intel.com> <4D232C20.80306@redhat.com> <4D232EB1.1000304@redhat.com>
In-Reply-To: <4D232EB1.1000304@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 01/04/2011 04:18 PM, Rik van Riel wrote:
>   
>>
>> So should I resend the patch with the ple_gap default
>> changed to 128, or are you willing to ack the current
>> patch?
>>
>>     
>
> I think 128 is safer given than 41 was too low.  We have to take into 
> account newer cpus and slower spin loops.  If the spin loop does a cache 
> ping-pong (which would be a bad, bad possible, implementation), even 128 
> might be too low.
>   

Agree with Avi. Let us use 128 at this point.
Thanks,
edwin
