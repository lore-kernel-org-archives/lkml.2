Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab1BQT51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:57:27 -0500
Received: from kroah.org ([198.145.64.141]:42940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab1BQT5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:57:07 -0500
Date: Thu, 17 Feb 2011 11:54:21 -0800
From: Greg KH <greg@kroah.com>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 07/12] n_tracerouter and n_tracesink additions.
Message-ID: <20110217195421.GC12172@kroah.com>
References: <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
 <20110217192154.GC29448@kroah.com>
 <1297971806.3038.30.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297971806.3038.30.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:43:26AM -0800, J Freyensee wrote:
> On Thu, 2011-02-17 at 11:21 -0800, Greg KH wrote:
> > On Tue, Feb 08, 2011 at 11:34:52AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > 
> > > This patch adds line discipline numbers to n_tracerouter and
> > > n_tracesink line disciplines for the Intel-Atom PTI implementation
> > > for mobile devices.
> > > 
> > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > ---
> > >  include/linux/tty.h |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/tty.h b/include/linux/tty.h
> > > index 54e4eaa..c507f53 100644
> > > --- a/include/linux/tty.h
> > > +++ b/include/linux/tty.h
> > > @@ -50,6 +50,8 @@
> > >  #define N_CAIF		20      /* CAIF protocol for talking to modems */
> > >  #define N_GSM0710	21	/* GSM 0710 Mux */
> > >  #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
> > > +#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
> > > +#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
> > 
> > Two new ones?  Really?  Alan, no objection from you on this?
> 
> I'll let Alan chime in, but I did have Alan review this code before I
> submitted here.

Hm, I don't see a "Reviewed-by:" line on the patch...

thanks,

greg k-h
