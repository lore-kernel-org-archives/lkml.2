Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1JZGH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:07:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab1JZGH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:07:56 -0400
Date: Wed, 26 Oct 2011 08:07:42 +0200
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, dmitry.torokhov@gmail.com,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/6] Staging: hv: mousevsc: Make  boolean states  boolean
Message-ID: <20111026060742.GA19973@suse.de>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
 <1319588392-9982-1-git-send-email-kys@microsoft.com>
 <1319587427.14932.7.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319587427.14932.7.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 05:03:47PM -0700, Joe Perches wrote:
> On Tue, 2011-10-25 at 17:19 -0700, K. Y. Srinivasan wrote:
> > Make some state that is boolean in nature, a boolean variable.
> []
> > diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> []
> @@ -148,7 +148,7 @@ struct  mousevsc_prt_msg {
> >   */
> >  struct mousevsc_dev {
> >  	struct hv_device	*device;
> > -	unsigned char		init_complete;
> > +	bool			init_complete;
> >  	struct mousevsc_prt_msg	protocol_req;
> >  	struct mousevsc_prt_msg	protocol_resp;
> >  	/* Synchronize the request/response if needed */
> > @@ -159,7 +159,7 @@ struct mousevsc_dev {
> >  	unsigned char		*report_desc;
> >  	u32			report_desc_size;
> >  	struct hv_input_dev_info hid_dev_info;
> > -	int			connected;
> > +	bool			connected;
> >  	struct hid_device       *hid_device;
> >  };
> 
> One of the bools should be moved to be adjacent to the other.

For a mouse driver, it really doesn't matter.

