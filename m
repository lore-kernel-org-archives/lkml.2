Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1HBJZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:25:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1HBJZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:25:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Regression] Commit 02c24a82187d5a628c68edfe71ae60dc135cd178 breaks s2disk
Date: Tue, 2 Aug 2011 11:26:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josef Bacik <josef@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Jan Kara <jack@suse.cz>
References: <201108020147.01136.rjw@sisk.pl> <20110802013027.GJ2203@ZenIV.linux.org.uk> <20110802013947.GK2203@ZenIV.linux.org.uk>
In-Reply-To: <20110802013947.GK2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108021126.58294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 02, 2011, Al Viro wrote:
> On Tue, Aug 02, 2011 at 02:30:27AM +0100, Al Viro wrote:
> 
> > Applied (in file->f_mapping variant; it is equal to bdev->bd_mapping,
> > but what's wrong with using ->f_mapping here?)
> 
> BTW, I've put s-o-b: Rafael J. Wysocki <rjw@sisk.pl> in there.  Rafael,
> do you have any problems with that?

Not at all.

Thanks a lot,
Rafael
