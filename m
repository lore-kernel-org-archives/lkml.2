Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2GRLmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:42:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58546 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2GRLmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:42:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120717150928.GB11587@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
	<20120717150928.GB11587@redhat.com>
Date: Wed, 18 Jul 2012 12:42:09 +0100
Message-ID: <CAJSP0QWKtsRDYB9uPPg7K8k2HHvgrQKBP9+biDwfyCmN=WmJqQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/5] Add vhost-blk support
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Asias He <asias@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-aio@kvack.org, target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        lf-virt <virtualization@lists.linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 4:09 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Fri, Jul 13, 2012 at 04:55:06PM +0800, Asias He wrote:
>>
>> Hi folks,
>>
>> [I am resending to fix the broken thread in the previous one.]
>>
>> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
>> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
>> gives about 5% to 15% performance improvement.
>
> Same thing as tcm_host comment:
>
>         It seems not 100% clear whether this driver will have major
>         userspace using it. And if not, it would be very hard to support a
>         driver when recent userspace does not use it in the end.
>
>         I think a good idea for 3.6 would be to make it depend on
>         CONFIG_STAGING.  Then we don't commit to an ABI.  For this, you can add
>         a separate Kconfig and source it from drivers/staging/Kconfig.  Maybe it
>         needs to be in a separate directory drivers/vhost/staging/Kconfig.
>
> I Cc'd the list of tcm_host in the hope that you can cooperate on this.
>

Adding it to staging allows more people to try it out, so that's a
good thing.  If I get a moment to play with it I'll let you know the
results.

Stefan
