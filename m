Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0IXT5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:57:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:56174 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0IXT5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:57:10 -0400
Date: Fri, 24 Sep 2010 12:30:27 -0700
From: Greg KH <gregkh@suse.de>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: drivers:staging:ti-st: merge issues.
Message-ID: <20100924193027.GA17728@suse.de>
References: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 02:11:50PM -0500, Pavan Savoy wrote:
> Stephen,
> 
> The merges bbf96b3cb54a237f1a66883390637e30bb4407ba and the merge on
> 759b9f0fe0c5be0d9fa1b92e14e093961312f6ac has caused the
> drivers/staging/ti-st to get corrupted, I had submitted few patches
> and it was all merged.
> 
> basically the merge for bbf96b3cb54a237f1a66883390637e30bb4407ba for
> drivers/staging/ti-st/ shouldn't have happened.
> The head for the drivers/staging/ti-st/ should have been @
> 83ef41f0858b48cce4f8ca23f674ec55d50bf47d

I have no idea what this all means, sorry.

Are these linux-next merges?

If I need to apply a patch to the staging-next, or Linus's tree, please
let me know.

confused,

greg k-h
