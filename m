Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1HBBj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:39:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60553 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1HBBjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:39:52 -0400
Date: Tue, 2 Aug 2011 02:39:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Josef Bacik <josef@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [Regression] Commit 02c24a82187d5a628c68edfe71ae60dc135cd178
 breaks s2disk
Message-ID: <20110802013947.GK2203@ZenIV.linux.org.uk>
References: <201108020147.01136.rjw@sisk.pl>
 <201108020217.48952.rjw@sisk.pl>
 <CA+55aFxPAowBwgK7JqN0uH-ytvg+BKdE3yBGF0z_6kNDNcOYcQ@mail.gmail.com>
 <20110802013027.GJ2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802013027.GJ2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 02:30:27AM +0100, Al Viro wrote:

> Applied (in file->f_mapping variant; it is equal to bdev->bd_mapping,
> but what's wrong with using ->f_mapping here?)

BTW, I've put s-o-b: Rafael J. Wysocki <rjw@sisk.pl> in there.  Rafael,
do you have any problems with that?
