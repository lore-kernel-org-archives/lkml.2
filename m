Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2IQNw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:52:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51081 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab2IQNwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:52:24 -0400
Date: Mon, 17 Sep 2012 09:52:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Marti Raudsepp <marti@juffo.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID: <20120917135215.GA26919@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <87fw6get5z.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw6get5z.fsf@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 04:21:44PM +0400, Dmitry Monakhov wrote:
> On Wed, 15 Aug 2012 22:46:54 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Wed, Aug 15, 2012 at 09:33:29PM +0300, Marti Raudsepp wrote:
> > > I was moving and deleting some files between two of my ext4 partitions
> > > when it suddenly crashed and dropped me into an kernel oops screen
> > > (below). I'm using ext4 on kernel 3.5.1 (Arch Linux). 
> Ohh, I've missed that gigantic topic, but still i've found the bug.
> patch is available here http://patchwork.ozlabs.org/patch/183649/

Dmitry, we have a patch in mainline already which addresses this, and
it's already backported to v3.5.3 or later.

What version was your patch series based against?

						- Ted
