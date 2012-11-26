Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2KZXti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:49:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:19278 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2KZXth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:49:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="247450382"
Message-ID: <50B40010.5050007@linux.intel.com>
Date: Mon, 26 Nov 2012 15:49:36 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Linux KVM mailing list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, kvm: Remove incorrect redundant assembly constraint
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com> <1353537681-18759-1-git-send-email-hpa@linux.intel.com> <50B318C5.8090508@redhat.com> <50B3F1D2.4010200@linux.intel.com> <20121126234820.GA2363@amt.cnet>
In-Reply-To: <20121126234820.GA2363@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 03:48 PM, Marcelo Tosatti wrote:
>>
>> Gleb, Marcelo: are you going to apply this or would you prefer I took it
>> in x86/urgent?
>>
>> 	-hpa
> 
> Feel free to merge it through x86/urgent.
> 

I presume that's an Acked-by?

	-hpa

