Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab0DBGoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab0DBGoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:44:12 -0400
Message-ID: <4BB59237.90203@redhat.com>
Date: Fri, 02 Apr 2010 09:44:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com> <201004010839.07451.pugs@lyon-about.com> <4BB4C1A6.8050904@redhat.com> <201004011427.07353.pugs@lyon-about.com>
In-Reply-To: <201004011427.07353.pugs@lyon-about.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 12:27 AM, Tom Lyon wrote:
>
>> kvm really wants the event counter to be an eventfd, that allows hooking
>> it directly to kvm (which can inject an interrupt on an eventfd_signal),
>> can you adapt your patch to do this?
>>      
> I looked further into eventfds - they seem the perfect solution for the
> MSI/MSI-X interrupts. Will include in V2.
>    

They are indeed.  Thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

