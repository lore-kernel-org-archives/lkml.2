Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967668Ab2EQTFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:05:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967636Ab2EQTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:05:43 -0400
Date: Thu, 17 May 2012 12:05:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [rfc 0/4] procfs fdinfo extension
Message-Id: <20120517120541.f2dbdee9.akpm@linux-foundation.org>
In-Reply-To: <20120517160738.116113099@openvz.org>
References: <20120517160738.116113099@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 20:07:38 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> when we do restore files such as eventfd/eventpoll we need to pass
> appropriate parameters to system calls.

What does "such as" mean?  Provide the whole list, please.  I assume
we're going to have to add ~100 lines of stuff to each and every one? 
Stuff which, according to this patchset, is needed even when
CONFIG_CHECKPOINT_RESTORE=n?

My reason for disliking our whole approach to integration of c/r is
that it exposes us to an ongoing trickle of nasty surprises.  This
patchset is one such nasty surprise, and we don't even know how
extensive this particular surprise will be.

And how many more surprises are we going to get?


I'm quite apprehensive about this, largely because it has so many
unknowns.  How much work would it be to prepare a full list of
everything that still needs to be done to fully implement c/r in Linux?
