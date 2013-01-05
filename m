Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3AEGZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 01:25:04 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63729 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3AEGZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 01:25:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130105033541.GA2501@netboy.at.omicron.at>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
	<20130105033541.GA2501@netboy.at.omicron.at>
Date: Sat, 5 Jan 2013 00:16:51 -0600
Message-ID: <CAD=GYpZp+QJqPkbejj6Kujv7XHHFrymriM5TCDJ626eaE7zPzw@mail.gmail.com>
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Fri, Jan 4, 2013 at 9:35 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Fri, Jan 04, 2013 at 09:31:04PM +0200, Pantelis Antoniou wrote:
>> The following patchset introduces Device Tree overlays, a method
>> of dynamically altering the kernel's live Device Tree.
>
> It would be nice to know the motivation for this code.
>
> What is the use case? What problem or issue is being addressed?

The problem being addressed is discussed in this thread:
http://permalink.gmane.org/gmane.linux.kernel/1389017

Regards,
Joel
