Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3AEJgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 04:36:17 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:47188 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3AEJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:36:14 -0500
Date: Sat, 5 Jan 2013 10:35:58 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Joel A Fernandes <agnel.joel@gmail.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
Message-ID: <20130105093558.GA31408@netboy.at.omicron.at>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
 <20130105033541.GA2501@netboy.at.omicron.at>
 <CAD=GYpZp+QJqPkbejj6Kujv7XHHFrymriM5TCDJ626eaE7zPzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=GYpZp+QJqPkbejj6Kujv7XHHFrymriM5TCDJ626eaE7zPzw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 12:16:51AM -0600, Joel A Fernandes wrote:
> 
> The problem being addressed is discussed in this thread:
> http://permalink.gmane.org/gmane.linux.kernel/1389017

Thanks for the link.

Since the motivation is already documented in that post, why not add
it into Documentation/devicetree/overlay-notes.txt as well?

Thanks,
Richard
