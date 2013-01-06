Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3AFQKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:10:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab3AFQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:10:44 -0500
Date: Sun, 6 Jan 2013 11:10:30 -0500
From: Dave Jones <davej@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: oops in copy_page_rep()
Message-ID: <20130106161030.GA16777@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hillf Danton <dhillf@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130105152208.GA3386@redhat.com>
 <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 07:55:53PM +0800, Hillf Danton wrote:

 > On Sat, Jan 5, 2013 at 11:22 PM, Dave Jones <davej@redhat.com> wrote:
 > > I have no idea what happened here, but this is the first time I've seen this one.
 > > This was running a tree pulled yesterday afternoon.
 > >
 > Would you please try the following patch?

I can, though it took a long time for me to hit this, so I can't guarantee
I'll be able to say with certainty whether it's working.
(perhaps there's a printk we could add for debugging to say "would have crashed here" ?)

(The fuzzer frequently walks into other bugs first, it's unusual that
it ran for the length of time it did when this happened)

	Dave

