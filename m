Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab1BBTiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:38:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab1BBTiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:38:11 -0500
Date: Wed, 2 Feb 2011 11:37:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: avi@redhat.com, mtosatti@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] Allow GUP to fail instead of waiting on a page.
Message-Id: <20110202113750.367a6fda.akpm@linux-foundation.org>
In-Reply-To: <20110202133157.GI14984@redhat.com>
References: <1296559307-14637-1-git-send-email-gleb@redhat.com>
	<1296559307-14637-2-git-send-email-gleb@redhat.com>
	<20110201164240.9a5c06e9.akpm@linux-foundation.org>
	<20110202133157.GI14984@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011 15:31:57 +0200
Gleb Natapov <gleb@redhat.com> wrote:

> > This?
> > 
> Yes, this is better. Thanks you. I see that the patch below is in your queue
> already. Should I re-spin my patch with improved comment anyway?

Nope, that's OK - I fold fixup patches into the base patch before
sending them onwards.

There's always a risk that someone will get a hold of an earlier
version of the patch, but a) sending out a v2 doesn't eliminate that
risk and b) it's not very important anyway (in this case) and c)
because I separate the base patch from the fixup patches, I'll easily
notice if someone merges an earlier patch, because I'm left holding
stray fixup patches.

