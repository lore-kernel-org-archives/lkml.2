Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2JHXY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:24:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59236 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2JHXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:24:51 -0400
Date: Tue, 9 Oct 2012 00:24:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/8] exofs: drop lock/unlock super
Message-ID: <20121008232447.GR2616@ZenIV.linux.org.uk>
References: <50700A1A.7@gmail.com>
 <50734C6D.2000400@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50734C6D.2000400@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 02:58:05PM -0700, Boaz Harrosh wrote:
> Hi Marco
> 
> I was sure you guys where pushing this patch through some
> vfs tree. (Hence my Acked-by below). I have just sent Linus
> a pull request for the 3.7 Kernel. I could perhaps append this
> one and resend.
> 
> I do want this patch, and it is completely independent and can
> go through my tree. Please tell me what do you want to do with
> this patch, should I push it? Or are you pushing it through Al

This series is slated for tonight push; I'm testing the tree right
now...
