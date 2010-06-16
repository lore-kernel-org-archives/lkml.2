Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0FPIkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab0FPIkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:40:43 -0400
Message-ID: <4C188E08.3060806@redhat.com>
Date: Wed, 16 Jun 2010 11:40:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 1/9] abstract kvm x86 mmu->n_free_mmu_pages
References: <20100615135518.BC244431@kernel.beaverton.ibm.com> <20100615135519.00781795@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135519.00781795@kernel.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:55 PM, Dave Hansen wrote:
> First of all, I think "free" is a poor name for this value.  In
> this context, it means, "the number of mmu pages which this kvm
> instance should be able to allocate."  To me, "free" implies
> much more that the objects are there and ready for use.  I think
> "available" is a much better description, especially when you
> see how it is calculated.
>
>    

Agreed.  Note that if reclaim is improved, we can drop it completely and 
let the kernel trim the cache when it grows too large.

-- 
error compiling committee.c: too many arguments to function

