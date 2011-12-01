Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1LAIt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:49:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1LAIt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:49:26 -0500
Message-ID: <4ED73F90.5050603@redhat.com>
Date: Thu, 01 Dec 2011 09:49:20 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: virtio-scsi spec (was Re: [PATCH] Add virtio-scsi to the virtio
 spec)
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com> <1322661042-28191-2-git-send-email-pbonzini@redhat.com> <4ED63AE1.8090105@suse.de> <4ED65BA4.3000003@redhat.com> <4ED74E54.3070303@suse.de>
In-Reply-To: <4ED74E54.3070303@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 10:52 AM, Hannes Reinecke wrote:
>>>>
>>> I would like to have the other request_queue limitations exposed
>>> here, too.
>>> Most notably we're missing the maximum size of an individual segment
>>> and the maximum size of the overall I/O request.
>>
>> The virtio transport does not put any limit, as far as I know.
>>
> Virtio doesn't, but the underlying device/driver might.
> And if we don't expose these values we cannot format the request correctly.

These limits should be per target/LUN, so it seems like material for 
another controlq command when the need arises.  For now, I'd really 
prefer to have the spec match the implementation (plus a few SAM 
bogosities).

Paolo
