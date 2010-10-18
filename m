Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0JRGgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:36:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab0JRGgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:36:11 -0400
Date: Sun, 17 Oct 2010 23:36:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
        kernel@lists.fedoraproject.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
        eparis@redhat.com
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-Id: <20101017233620.0db45dd9.akpm@linux-foundation.org>
In-Reply-To: <20101018062530.GD8332@bombadil.infradead.org>
References: <20101016065206.GO4681@dastard>
	<20101016192027.GA6883@infradead.org>
	<ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
	<20101017004945.GE1614@infradead.org>
	<20101017054008.GA16383@elte.hu>
	<20101017184652.GB28060@infradead.org>
	<alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
	<20101018062530.GD8332@bombadil.infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 02:25:30 -0400 Kyle McMartin <kyle@mcmartin.ca> wrote:

> Subject: [PATCH] ima: allow it to be completely disabled (and default to off)

Good enough as a short-term thing I guess.

But the memory consumption which David described is plain nuttiness and
needs to be fixed, presumably by using a more appropriate data structure
for lookups.

However unless I missed it, nobody has yet stated that they intend to
fix this?
