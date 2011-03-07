Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1CGDju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:39:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1CGDjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:39:49 -0500
Date: Sun, 6 Mar 2011 19:39:32 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH next] staging: gma500: fix build according to drm
 changes
Message-ID: <20110307033932.GA2970@suse.de>
References: <1299465664-7760-1-git-send-email-a.beregalov@gmail.com>
 <AANLkTin2h7tKkNCA2AW66FyyuYafPNo4fpwUNYmFxh7x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin2h7tKkNCA2AW66FyyuYafPNo4fpwUNYmFxh7x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 05:48:10AM +0300, Alexander Beregalov wrote:
> On 7 March 2011 05:41, Alexander Beregalov <a.beregalov@gmail.com> wrote:
> > Commit 8410ea3b (drm: rework PCI/platform driver interface.)
> > changed drm_driver structure. Fix build according to these changes.
> >
> 
> Sorry, I forget to check LKML first, there is a patch already.

Yeah, I really can't apply it until the merge window time, sorry.

thanks,

greg k-h
