Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab1BQULh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:11:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:61471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab1BQULf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:11:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,182,1297065600"; 
   d="scan'208";a="888598787"
Subject: Re: [PATCH 07/12] n_tracerouter and n_tracesink additions.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
In-Reply-To: <20110217195421.GC12172@kroah.com>
References: <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110217192154.GC29448@kroah.com> <1297971806.3038.30.camel@localhost>
	 <20110217195421.GC12172@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 17 Feb 2011 12:11:34 -0800
Message-ID: <1297973494.3038.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:54 -0800, Greg KH wrote:
> On Thu, Feb 17, 2011 at 11:43:26AM -0800, J Freyensee wrote:
> > On Thu, 2011-02-17 at 11:21 -0800, Greg KH wrote:
> > > On Tue, Feb 08, 2011 at 11:34:52AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > 
> > > > This patch adds line discipline numbers to n_tracerouter and
> > > > n_tracesink line disciplines for the Intel-Atom PTI implementation
> > > > for mobile devices.
> > > > 
> > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > ---
> > > >  include/linux/tty.h |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/include/linux/tty.h b/include/linux/tty.h
> > > > index 54e4eaa..c507f53 100644
> > > > --- a/include/linux/tty.h
> > > > +++ b/include/linux/tty.h
> > > > @@ -50,6 +50,8 @@
> > > >  #define N_CAIF		20      /* CAIF protocol for talking to modems */
> > > >  #define N_GSM0710	21	/* GSM 0710 Mux */
> > > >  #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
> > > > +#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
> > > > +#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
> > > 
> > > Two new ones?  Really?  Alan, no objection from you on this?
> > 
> > I'll let Alan chime in, but I did have Alan review this code before I
> > submitted here.
> 
> Hm, I don't see a "Reviewed-by:" line on the patch...

Good point...I can add this to all patches as Alan reviewed all this
code before-hand.

> 
> thanks,
> 
> greg k-h


