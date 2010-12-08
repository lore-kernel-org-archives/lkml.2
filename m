Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0LHWih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:38:37 -0500
Received: from kroah.org ([198.145.64.141]:59761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab0LHWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:37:48 -0500
Date: Wed, 8 Dec 2010 14:27:07 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20101208222707.GB31802@kroah.com>
References: <20101202132254.93e019c7.sfr@canb.auug.org.au>
 <20101202040031.GA10016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202040031.GA10016@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 08:00:31PM -0800, Greg KH wrote:
> On Thu, Dec 02, 2010 at 01:22:54PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/winbond/sysdef.h between commit
> > 412dc7f368bf10a8049a8a4c41abbfd0108742e7 ("staging: fix winbond build,
> > needs delay.h") from the staging.current tree and commit
> > ddee7e28e7d5e4ba2b8537c6a59b035745c250bb ("Staging: w35und: Remove empty
> > sysdef.h header") from the staging tree.
> > 
> > I removed the file.  I wonder if
> > drivers/staging/winbond/phy_calibration.c and
> > drivers/staging/winbond/reg.c now need their own includes of
> > linux/delay.h ...
> 
> Heh, probably.  I'll handle this merge when thes staging.current code
> goes to Linus this week.

Now merged so this conflict should have gone away.

thanks,

greg k-h
