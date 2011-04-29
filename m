Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab1D2VHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:07:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37216 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759839Ab1D2VH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:07:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Generic clock manipulation rountines for runtime PM (v3)
Date: Fri, 29 Apr 2011 23:07:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Colin Cross <ccross@google.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104280258.34694.rjw@sisk.pl> <20110429205039.GB7497@ponder.secretlab.ca>
In-Reply-To: <20110429205039.GB7497@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104292307.35070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 29, 2011, Grant Likely wrote:
> On Thu, Apr 28, 2011 at 02:58:34AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, April 28, 2011, Colin Cross wrote:
> > > On Wed, Apr 27, 2011 at 2:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > +void pm_runtime_clk_remove(struct device *dev, const char *con_id)
> > > > +{
> > > > +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> > > > +       struct pm_clock_entry *ce;
> > > > +
> > > > +       if (!prd)
> > > > +               return;
> > > > +
> > > > +       mutex_lock(&prd->lock);
> > > > +
> > > > +       list_for_each_entry(ce, &prd->clock_list, node)
> > > Braces
> > 
> > No, this is correct as is.
> 
> The code is correct, but Colin's comment is valid.  Braces do make it
> easier for a reader to properly interpret the scope of large multiline
> blocks, even if it does resolve to a single statement.

OK, I'll add the braces.

Thanks,
Rafael
