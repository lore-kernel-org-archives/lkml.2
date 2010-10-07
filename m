Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0JGUof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:44:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:22629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab0JGUod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,298,1283756400"; 
   d="scan'208";a="333484537"
Message-ID: <4CAE3130.4010908@intel.com>
Date: Thu, 07 Oct 2010 13:44:32 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "caiqian@redhat.com" <caiqian@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
References: <4CABAF2A.5090501@kernel.org> <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org> <20101006151449.GA7378@redhat.com> <4CACF531.2060407@intel.com> <20101006224704.GD7378@redhat.com> <4CAD01A9.9050907@intel.com> <20101007181804.GE23308@redhat.com> <4CAE1767.5040409@intel.com> <20101007192129.GC2581@redhat.com>
In-Reply-To: <20101007192129.GC2581@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 12:21 PM, Vivek Goyal wrote:
>>
>> It would be easy enough to either deprecate or make it an alias for
>> crashkernel=...<896M, which is basically what Yinghai's patch does.
> 
> Agreed.
> 
> So Yinghai's patch is fine. I need to write a patch for introducing
> crashkernel=X<Y syntax to make the behavior explicit. Will do...
> 

Sounds like a plan.  Thanks!

	-hpa
