Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2C0NFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:05:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41735 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2C0NE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:04:57 -0400
Date: Tue, 27 Mar 2012 17:03:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-ID: <20120327130350.GB7972@lizard>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
 <20120326161132.GA6430@lizard>
 <20120327084414.dacbf074e0f4ddd65ff3ecfb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120327084414.dacbf074e0f4ddd65ff3ecfb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 08:44:14AM +1100, Stephen Rothwell wrote:
> Hi Anton,
> 
> On Mon, 26 Mar 2012 20:11:32 +0400 Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> >
> > I pulled my current battery tree into next-20120326, and I can't reproduce
> > the issue (using allmodconfig on x86_64).
> 
> I have moved the battery tree to after the mfd tree in my merge sequence
> so we will see if that helps.  I really hate having ordering dependencies
> in linux-next (since they change over time and people have to remember to
> tell me and to send stuff to Linus in the right order).  Also, it means
> that you are not testing exactly what you are sending to me - I assume
> that your testing must be including the mfd tree somehow.
> 
> These sort of things should be fixed by having the common code in a
> separate (stable) branch that is merged into both trees.  Or in some
> cases by merely cherry-picking a very small number of commits from one
> tree to the other.

Yes, I was thinking about cherry-picking a few MFD patches, but
decided not to as the driver is quite big and completely new, so
it would have some glitches anyway, and thus would need fixups.
One less, one more.

But for such drivers I usually give my 'Acked-by' so that
patches could be merged via single tree (i.e. mfd). But nobody
asked me in this case.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
