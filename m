Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2DSOuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 10:50:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45916 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab2DSOuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 10:50:13 -0400
Date: Thu, 19 Apr 2012 10:50:07 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120419145007.GD6317@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Anton Blanchard <anton@au1.ibm.com>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <1334805798.3143.25.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334805798.3143.25.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 01:23:18PM +1000, Benjamin Herrenschmidt wrote:
> >       ext4: fix endianness breakage in ext4_split_extent_at()
> 
> That smells like something we'd want in -stable no ?

Yes, commit af1584f5 is something that should definitely go into
-stable.


					- Ted
