Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab1DXXKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 19:10:12 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13240 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab1DXXKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 19:10:09 -0400
Date: Mon, 25 Apr 2011 01:03:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@suse.de>
cc: james_p_freyensee@linux.intel.com, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
Subject: Re: [PATCH 4/4] n_tracerouter and n_tracesink ldisc additions.
In-Reply-To: <20110424015116.GA689@suse.de>
Message-ID: <alpine.LNX.2.00.1104250102480.32416@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com> <1303515150-1718-5-git-send-email-james_p_freyensee@linux.intel.com> <alpine.LNX.2.00.1104240256160.28014@swampdragon.chaosbits.net> <20110424015116.GA689@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011, Greg KH wrote:

> On Sun, Apr 24, 2011 at 03:04:31AM +0200, Jesper Juhl wrote:
> > > --- a/include/linux/tty.h
> > > +++ b/include/linux/tty.h
> > > @@ -50,6 +50,8 @@
> > >  #define N_CAIF		20      /* CAIF protocol for talking to modems */
> > >  #define N_GSM0710	21	/* GSM 0710 Mux */
> > >  #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
> > > +#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
> > > +#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
> > >  
> > 
> > Lining up those defines would be nice :)
> 
> They are lined up in the original file just fine.
> 
Ok, then my email client is messing things up for me.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

