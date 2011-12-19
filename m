Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1LSPSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:18:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1LSPSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:18:40 -0500
Message-ID: <4EEF559E.2040709@redhat.com>
Date: Mon, 19 Dec 2011 16:17:50 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 1/2] virtio-scsi: first version
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-2-git-send-email-pbonzini@redhat.com> <4EEF2C86.6010003@suse.de> <4EEF380E.6040101@redhat.com> <4EEF5192.50201@interlog.com>
In-Reply-To: <4EEF5192.50201@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 04:00 PM, Douglas Gilbert wrote:
>>
>> This happens when you send an INQUIRY with a sglist of 255 bytes and an
>> ALLOCATION LENGTH of 300 bytes. The spec says "VIRTIO_SCSI_S_UNDERRUN [is
>> returned] if the content of the CDB requires transferring more data
>> than is
>> available in the data buffers".
>
> Overrun! That is overrun.

We're still in time to fix the spec.  Thanks.

Paolo
