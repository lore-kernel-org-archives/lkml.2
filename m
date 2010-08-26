Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0HZSUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:20:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48556 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0HZSU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:20:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [PATCH] pm_qos: Fix inline documentation.
Date: Thu, 26 Aug 2010 20:18:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
References: <1282801975-18348-1-git-send-email-skannan@codeaurora.org> <20100826160126.GA3414@gvim.org>
In-Reply-To: <20100826160126.GA3414@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008262018.45164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 26, 2010, mark gross wrote:
> Acked-by: mark gross <markgross@thegnar.org>

Applied to suspend-2.6/pm-fixes .

Thanks,
Rafael


> On Wed, Aug 25, 2010 at 10:52:55PM -0700, Saravana Kannan wrote:
> > Change-Id: I32f95b5a7e92236931b38fc4f1474f46ad22e298
> > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> > ---
> >  kernel/pm_qos_params.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index 996a4de..132471f 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -212,15 +212,17 @@ EXPORT_SYMBOL_GPL(pm_qos_request_active);
> >  
> >  /**
> >   * pm_qos_add_request - inserts new qos request into the list
> > - * @pm_qos_class: identifies which list of qos request to us
> > + * @dep: pointer to a preallocated handle
> > + * @pm_qos_class: identifies which list of qos request to use
> >   * @value: defines the qos request
> >   *
> >   * This function inserts a new entry in the pm_qos_class list of requested qos
> >   * performance characteristics.  It recomputes the aggregate QoS expectations
> > - * for the pm_qos_class of parameters, and returns the pm_qos_request list
> > - * element as a handle for use in updating and removal.  Call needs to save
> > - * this handle for later use.
> > + * for the pm_qos_class of parameters and initializes the pm_qos_request_list
> > + * handle.  Caller needs to save this handle for later use in updates and
> > + * removal.
> >   */
> > +
> >  void pm_qos_add_request(struct pm_qos_request_list *dep,
> >  			int pm_qos_class, s32 value)
> >  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

