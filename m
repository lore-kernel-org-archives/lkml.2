Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2EFWFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 18:05:53 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:61571 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754753Ab2EFWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 18:05:52 -0400
Message-ID: <1336341946.8274.228.camel@deadeye>
Subject: RE: [PATCH net-next 1/3] Add capability to retrieve plug-in module
 EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Yaniv Rosner <yaniv.rosner@broadcom.com>
CC: "smhodgson@solarflare.com" <smhodgson@solarflare.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bruce.w.allan@intel.com" <bruce.w.allan@intel.com>,
        "decot@google.com" <decot@google.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Date: Sun, 6 May 2012 23:05:46 +0100
In-Reply-To: <A6AA2EF896BED345B0F23520D832A4B106AD8E@SJEXCHMB05.corp.ad.broadcom.com>
References: <4F9031BF.10106@solarflare.com>
	 <20120423.172848.1733968863825393980.davem@davemloft.net>
	 <1335289485.17274.46.camel@bwh-desktop.uk.solarflarecom.com>
	 <A6AA2EF896BED345B0F23520D832A4B106AD8E@SJEXCHMB05.corp.ad.broadcom.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18888.005
X-TM-AS-Result: No--23.000100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-06 at 08:02 +0000, Yaniv Rosner wrote:
> > On Mon, 2012-04-23 at 17:28 -0400, David Miller wrote:
> > > You can't just submit three seperate patches each with the same exact
> > > Subject line.
> > >
> > > Otherwise someone scanning the commit headers can't figure out what
> > > is different in each of these changes.
> > >
> > > There also is no signoff from Ben for patches #2 or #3, did he review
> > > them?  If so, why didn't he ACK or sign off on it?  If not, why not?
> > 
> > Sorry, I've been busy with another project.  I'll reply to Stuart's
> > patches faster next round.
> > 
> > Ben.
> 
> Hi Stuart,
> It's been 3 weeks since you sent the initial patch series which were not
> accepted. Please reply if you're going to resubmit fixed patches soon,
> otherwise I'll take over, and complete this task from where you left it.

I'll be making a pull request including Stuart's patches in the next few
days.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

