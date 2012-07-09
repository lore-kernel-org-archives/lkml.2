Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2GIAjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 20:39:53 -0400
Received: from ozlabs.org ([203.10.76.45]:60258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2GIAjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 20:39:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, amit.shah@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com
Subject: Re: [PATCH] MAINTAINERS: add kvm list for virtio components
In-Reply-To: <20120705122225.GA30572@redhat.com>
References: <1341482827-13195-1-git-send-email-pbonzini@redhat.com> <20120705122225.GA30572@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 09 Jul 2012 10:07:32 +0930
Message-ID: <878vet3h2r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012 15:22:25 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Jul 05, 2012 at 12:07:07PM +0200, Paolo Bonzini wrote:
> > The KVM list is followed by more people than the generic
> > virtualization@lists.linux-foundation.org mailing list, and is
> > already "de facto" the place where virtio patches are posted.
> 
> I have no data on the first statement (do you?) and I disagree with the
> last statement, but have no objection to people adding kvm list as well.

Well, the kvm list is far more active.  It's annoying to have two lists,
but it is how things are so best to document it.

I'm OK with the original commit message, but MST is smarter than me, so
let's do what he suggests :)

Cheers,
Rusty.
