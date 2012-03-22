Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab2CVSbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:31:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47348 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2CVSbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:31:44 -0400
Date: Thu, 22 Mar 2012 14:31:35 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Message-ID: <20120322183135.GC4028@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Artem Bityutskiy <dedekind1@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala>
 <20120322162825.GA4028@thunk.org>
 <20120322164751.GA17885@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322164751.GA17885@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 05:47:51PM +0100, Thierry Reding wrote:
> 
> Do you still want me to prepare a patch to unexport ext2_fs.h or will you
> take care of it?

If you could do it, that would be great.  I've been a bit overloaded
lately, so the more I can delegate to others, the better....

Thanks,

					- Ted
