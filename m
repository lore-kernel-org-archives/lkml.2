Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2BNAKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:10:31 -0500
Received: from ozlabs.org ([203.10.76.45]:58967 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab2BNAK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:10:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christian Hoff <christian.hoff@de.ibm.com>, BORNTRAE@linux.vnet.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
In-Reply-To: <4F38D5BC.8010705@redhat.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>  <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com>  <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com>  <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>  <4F313526.2050907@redhat.com>  <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>  <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com> <4F38D5BC.8010705@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Feb 2012 10:37:46 +1030
Message-ID: <87ipjacm5p.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 10:19:56 +0100, Paolo Bonzini <pbonzini@redhat.com> wrote:
> block layer _is_ growing support for new operations: discard is already 
> there, write same is in the works, extended copy will also come in due 
> time.  Perhaps we'll add them to virtio-blk, perhaps not.

FYI, I'd take patches for discard in virtio_blk today; it's a no-brainer
in a virtual devoce.

But I wouldn't want extended copy and write same.

Thanks,
Rusty.
