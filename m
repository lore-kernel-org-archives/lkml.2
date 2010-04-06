Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0DFQya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab0DFQyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:54:24 -0400
Message-ID: <4BBB622F.4070501@redhat.com>
Date: Tue, 06 Apr 2010 19:32:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com>
In-Reply-To: <20100405225833.GA25970@dtor-ws.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 01:58 AM, Dmitry Torokhov wrote:
>
>> Also please explain the applicability of this driver.  Will xen use it?
>> kvm?  Out-of-tree code?
>>      
> The driver is expected to be used on VMware platform - mainly ESX.
> Originally we tried to converge with KVM and use virtio and
> stock virtio_balloon driver but Avi mentioned that our code emulating
> virtqueue was more than balloon code itself and thus using virtio did
> not make nuch sense.
>    

Yeah.  If we wanted commonality, we could make a balloon_core.c that 
contains the common code.  IMO that's premature, but perhaps there's 
some meat there (like suspend/resume support and /proc//sys interface).

-- 
error compiling committee.c: too many arguments to function

