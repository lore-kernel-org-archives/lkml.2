Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1LBT6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:58:14 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43830 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab1LBT6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:58:13 -0500
X-Sasl-enc: icJk7WszEWVqEsHDyd6RpObxetztacsFnU5Jm9BgVERG 1322855892
Date: Fri, 2 Dec 2011 11:58:09 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files
Message-ID: <20111202195809.GA14660@kroah.com>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
 <1322851407-17182-2-git-send-email-andi@firstfloor.org>
 <20111202191724.GA13613@kroah.com>
 <20111202194219.GU24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202194219.GU24062@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 08:42:19PM +0100, Andi Kleen wrote:
> On Fri, Dec 02, 2011 at 11:17:24AM -0800, Greg KH wrote:
> > I like this, but some documentation will probably need to be added
> > somwhere saying that it's now legal to create a debugfs file with
> > "this/is/a/tree" and have it all be expanded out.
> 
> Ok. Updating the kerneldoc entries.
> 
> > 
> > And yes, cleaning up the directories shouldn't be a big issue, but what
> > if the directory is already there and it tries to be created again?
> > Shouldn't you do a lookup first and use that dentry if it's there?
> 
> In this case debugfs_create_dir() errors out, the caller ignores
> the error and just looks it up. So yes should work.

Ah, ok, nevermind then :)

thanks,

greg k-h
