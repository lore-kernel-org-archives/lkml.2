Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0DFRmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab0DFRmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:42:17 -0400
Message-ID: <4BBB726D.6000803@redhat.com>
Date: Tue, 06 Apr 2010 20:42:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com> <4BBB622F.4070501@redhat.com> <20100406170639.GA20948@dtor-ws.eng.vmware.com>
In-Reply-To: <20100406170639.GA20948@dtor-ws.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 08:06 PM, Dmitry Torokhov wrote:
>
>> some meat there (like suspend/resume support and /proc//sys interface).
>>      
> We do not need any special suspend/resume support - the freezeable
> workqueue is stopped when suspending.
>    

Ah, virtio_balloon should do the same.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

