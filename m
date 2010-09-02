Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0IBUK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:10:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab0IBUKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:10:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Date: Thu, 2 Sep 2010 22:09:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org> <87hbigqg8d.fsf@deeprootsystems.com> <20100902140546.GA2818@gvim.org>
In-Reply-To: <20100902140546.GA2818@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022209.20354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, mark gross wrote:
> On Fri, Aug 27, 2010 at 07:31:46AM -0700, Kevin Hilman wrote:
> > Saravana Kannan <skannan@codeaurora.org> writes:
> > 
> > > Some drivers/devices might need some minimum system bus performance to
> > > provide acceptable service. Provide a PM QoS parameter to send these requests
> > > to.
> > >
> > > The new parameter is named "system bus performance" since it is generic enough
> > > for the unit of the request to be frequency, bandwidth or something else that
> > > might be appropriate. It's up to each implementation of the QoS provider to
> > > define what the unit of the request would be.
> > >
> > > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> > 
> > With this current design, only one system-wide bus would be managed.
> > What if a platform has more than one independently scalable bus?
> > 
> > I think the only scalable way to handle this kind of thing is to have
> > per-device QoS constraints that can then be combined/aggregated by parent
> > devices/busses.
> > 
> > At LPC this year, I've proposed per-device QoS constraints[1] as a topic
> > for the PM mini-conf.  I hope some folks from the MSM camp can be there
> > for these discussions.
> > 
> > Kevin
> > 
> > [1] http://www.linuxplumbersconf.org/2010/ocw/proposals/819
> 
> I thought a pm_qos like thing per bus would be a patch or you where
> going to put up to the driver model. ;)
> 
> The current pm_qos would stick around for higher level pm_qos things.
> So making the system bus and changing to a summation aggregation would
> be  temporary thing.  
> 
> Or are you you saying we shouldn't put system_bus into pm_qos at all and
> instead we should put effort into adding it to the driver model for
> buses?

Hmm, well, what's system_bus?

Rafael
