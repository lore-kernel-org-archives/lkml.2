Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1DXOYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 10:24:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:34654 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1DXOYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 10:24:46 -0400
Date: Sat, 23 Apr 2011 18:51:16 -0700
From: Greg KH <gregkh@suse.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: james_p_freyensee@linux.intel.com, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
Subject: Re: [PATCH 4/4] n_tracerouter and n_tracesink ldisc additions.
Message-ID: <20110424015116.GA689@suse.de>
References: <james_p_freyensee@linux.intel.com>
 <1303515150-1718-5-git-send-email-james_p_freyensee@linux.intel.com>
 <alpine.LNX.2.00.1104240256160.28014@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1104240256160.28014@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 03:04:31AM +0200, Jesper Juhl wrote:
> > --- a/include/linux/tty.h
> > +++ b/include/linux/tty.h
> > @@ -50,6 +50,8 @@
> >  #define N_CAIF		20      /* CAIF protocol for talking to modems */
> >  #define N_GSM0710	21	/* GSM 0710 Mux */
> >  #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
> > +#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
> > +#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
> >  
> 
> Lining up those defines would be nice :)

They are lined up in the original file just fine.

thanks,

greg k-h
