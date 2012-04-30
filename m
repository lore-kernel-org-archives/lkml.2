Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2D3Ukx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:40:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60582 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab2D3Ukv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:40:51 -0400
Message-ID: <4F9EF8C2.7030103@zytor.com>
Date: Mon, 30 Apr 2012 13:40:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
References: <20120430143902.GA10181@redhat.com> <4F9EF7FA.3060007@codemonkey.ws>
In-Reply-To: <4F9EF7FA.3060007@codemonkey.ws>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 01:37 PM, Anthony Liguori wrote:
> On 04/30/2012 09:39 AM, Michael S. Tsirkin wrote:
>> cpuid eax should return the max leaf so that
>> guests can find out the valid range.
>> This matches Xen et al.
> 
> What KVM does here predates Xen and Hyper-V.
> 
> This is an ABI breaker.
> 

What Intel and AMD have done here predates KVM...

What exactly relies on a zero here?

	-hpa

