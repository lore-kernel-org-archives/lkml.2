Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2JCGri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:47:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34297 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2JCGrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121003152921.c08e7019d2ada843888a2570@canb.auug.org.au>
References: <20121003152921.c08e7019d2ada843888a2570@canb.auug.org.au>
Date: Wed, 3 Oct 2012 09:47:34 +0300
X-Google-Sender-Auth: ikBiFuh8QUG5zDnY7gt3KO6o_1w
Message-ID: <CAOJsxLFeVa6WCpr25t3hA3xGJb6rUgFqOLDrc5_3iLnUb-xTHw@mail.gmail.com>
Subject: Re: linux-next: fate of the kvmtool tree
From: Pekka Enberg <penberg@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Oct 3, 2012 at 8:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Well, here we are at another merge window and the kvmtool tree is still
> not merged.  So, is it likely that it will be merged in this merge
> window?  or the next?  If not, can I please remove it from linux-next
> (and have it removed from the auto-latest branch of the tip tree) as it
> just adds weight to the patches and the tree that people have to fetch to
> work with.

I have no idea how likely it is that it will be merged but I'm
planning to send a pull request for this merge cycle. ;-)

Btw, IIRC the KVM tool also ends up in linux-next via Ingo's tree so
dropping my tree might not be enough.

                        Pekka
