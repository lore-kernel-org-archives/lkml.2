Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1LBBLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:11:00 -0500
Received: from ozlabs.org ([203.10.76.45]:41832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab1LBBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] Add virtio-scsi to the virtio spec
In-Reply-To: <4ED74102.6040207@redhat.com>
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com> <87sjl5rnj6.fsf@rustcorp.com.au> <4ED74102.6040207@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 02 Dec 2011 11:21:44 +1030
Message-ID: <87ty5jre1r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011 09:55:30 +0100, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 12/01/2011 04:14 AM, Rusty Russell wrote:
> > I'd prefer to see the spec only cover things
> > which are implemented and tested, otherwise the risk of a flaw in the
> > spec is really high in my experience.
> 
> In general I agree, and I did that for virtio-specific things such as 
> the eventq and the configuration space.  This is also why I don't want 
> to add untested controlq requests that people suggested.
> 
> However, there's tension between this and providing a complete SCSI 
> transport.  SCSI is roughly defined as a set of RPC interfaces ("Send 
> command", "Abort task", etc.) and transports provide the RPC protocol. 
> The SCSI command set changes relatively often, but the RPC interfaces 
> are pretty stable.  This stability limits the risk, and having a mapping 
> for all interfaces also makes future changes less likely.

OK, I expect that someone reading the spec will be SCSI-familiar more
than virtio-familiar, so it's more important that they be comfortable,
than that I be comfortable.

Thanks!
Rusty.
