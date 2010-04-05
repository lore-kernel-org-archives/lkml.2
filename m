Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0DEW1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab0DEW06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:26:58 -0400
Message-ID: <4BBA6383.7070601@redhat.com>
Date: Tue, 06 Apr 2010 01:26:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Dmitry Torokhov <dtor@vmware.com>,
       linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>	<20100405142419.2c9bea3d.akpm@linux-foundation.org>	<4BBA5E1C.10706@goop.org> <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
In-Reply-To: <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 01:17 AM, Andrew Morton wrote:
>> The basic idea of the driver is to allow a guest system to give up
>> memory it isn't using so it can be reused by other virtual machines (or
>> the host itself).
>>      
> So...  does this differ in any fundamental way from what hibernation
> does, via shrink_all_memory()?
>    

Just the _all_ bit, and the fact that we need to report the freed page 
numbers to the hypervisor.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

