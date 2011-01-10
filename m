Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1AJTbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:31:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828Ab1AJTbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:31:42 -0500
MIME-Version: 1.0
In-Reply-To: <4D2ACFA7.6000502@redhat.com>
References: <4D2ACFA7.6000502@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Jan 2011 11:31:21 -0800
Message-ID: <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 1:21 AM, Avi Kivity <avi@redhat.com> wrote:
>
> - asynchronous page faults, which allow a guest to continue processing
> interrupts even when its memory is being paged in; in the case of a Linux
> 2.6.38+ guest, it will receive a notification that the host is servicing a
> page fault, and may switch into another guest process

So quite frankly, I don't like how this was done.

When you touch files like mm/memory.c, you don't just touch them. You
get sign-offs and acks from the VM maintainers. Seriously.

In this case, I pulled, looked, and then unpulled. I just don't want
it, and I think the new FAULT_FLAG_MINOR is seriously mis-named and
hacky.

Is it about atomicity? Is it about IO? Why wasn't I notified
before-hand? Was Andrew cc'd?

Not pulled.

                     Linus
