Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2JIQkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:40:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34027 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2JIQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:40:45 -0400
Date: Tue, 9 Oct 2012 17:40:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/8] exofs: drop lock/unlock super
Message-ID: <20121009164040.GV2616@ZenIV.linux.org.uk>
References: <50700A1A.7@gmail.com>
 <50734C6D.2000400@panasas.com>
 <20121008232447.GR2616@ZenIV.linux.org.uk>
 <507448E0.4040305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507448E0.4040305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:55:12PM +0200, Marco Stornelli wrote:

> Thanks Al. For me there aren't problems to push it via Al or via
> other trees. For example the patch for ext4 is in Ted's tree. You
> tell me what you want and I do it :)

Um...  Then I'd better drop the ext4 part and hold the final one back,
right?  Are there other commits I need to skip to avoid duplicates with
the stuff already in other trees?
