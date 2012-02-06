Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab2BGAaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:30:14 -0500
Received: from ozlabs.org ([203.10.76.45]:48299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab2BGAaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:30:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3] Add virtio-scsi to the virtio spec
In-Reply-To: <1328439694-18705-1-git-send-email-pbonzini@redhat.com>
References: <1328439694-18705-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 07 Feb 2012 10:06:04 +1030
Message-ID: <87ehu7ilgb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Feb 2012 12:01:34 +0100, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Hi Rusty,
> 
> here is the specification for a virtio-based SCSI host (controller, HBA,
> you name it) so that you can apply it to the spec document and publish it.
> 
> I changed the index from 7 to 8 to account for the rpmsg device,
> and added a feature bit to tell the guest in advance whether the host
> supports hotplug.  Otherwise there is no change from v2.
> 
> Paolo

Thanks, applied!

I will release a new draft version shortly.

Cheers,
Rusty.
