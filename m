Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2H3Pp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:45:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2H3Pp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:45:26 -0400
Message-ID: <503F8A8F.3090709@redhat.com>
Date: Thu, 30 Aug 2012 17:45:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Multiqueue virtio-scsi
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <20120830145352.GA21724@redhat.com>
In-Reply-To: <20120830145352.GA21724@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/08/2012 16:53, Michael S. Tsirkin ha scritto:
>> > this series adds multiqueue support to the virtio-scsi driver, based
>> > on Jason Wang's work on virtio-net.  It uses a simple queue steering
>> > algorithm that expects one queue per CPU.  LUNs in the same target always
>> > use the same queue (so that commands are not reordered); queue switching
>> > occurs when the request being queued is the only one for the target.
>> > Also based on Jason's patches, the virtqueue affinity is set so that
>> > each CPU is associated to one virtqueue.
> 
> Is there a spec patch? I did not see one.

It was already in the first version of the spec, just not implemented
until now.

Paolo
