Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0GIWbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:31:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab0GIWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:31:51 -0400
Date: Fri, 9 Jul 2010 15:31:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/1] VFS: introduce s_dirty accessors
Message-Id: <20100709153146.fc7d1a6b.akpm@linux-foundation.org>
In-Reply-To: <20100709222737.GB27019@thunk.org>
References: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
	<1278335067.29620.51.camel@localhost>
	<20100709222737.GB27019@thunk.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 18:27:37 -0400
tytso@mit.edu wrote:

> On Mon, Jul 05, 2010 at 04:04:27PM +0300, Artem Bityutskiy wrote:
> > Linus,
> > 
> > I wonder, you did not take this because of the vacation or because you
> > do not like it?
> 
> I'd suggest resending the patch to Linus.
> 

this:

: commit 140236b4b1c749c9b795ea3d11558a0eb5a3a080
: Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
: Date:   Thu Jun 10 13:56:33 2010 +0300
: 
:     VFS: introduce s_dirty accessors

was merged into mainline a few days ago?
