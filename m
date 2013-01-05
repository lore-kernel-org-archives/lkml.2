Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3AEKNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 05:13:53 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:33221 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483Ab3AEKNv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 05:13:51 -0500
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <20130105033541.GA2501@netboy.at.omicron.at> <CAD=GYpZp+QJqPkbejj6Kujv7XHHFrymriM5TCDJ626eaE7zPzw@mail.gmail.com> <20130105093558.GA31408@netboy.at.omicron.at>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130105093558.GA31408@netboy.at.omicron.at>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-Id: <55B9348E-31B8-45C0-9DA2-7102480F55E5@antoniou-consulting.com>
Cc: Joel A Fernandes <agnel.joel@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
X-Mailer: iPad Mail (10A523)
From: Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
Date: Sat, 5 Jan 2013 12:13:39 +0200
To: Richard Cochran <richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

It should, but there are a few differences in the syntax plus the fact that I didn't write it.
It should go in by a separate patch by the original author. 

Regards

-- Pantelis

Από το iPad μου

5 Ιαν 2013, 11:35 π.μ., ο/η Richard Cochran <richardcochran@gmail.com> έγραψε:

> On Sat, Jan 05, 2013 at 12:16:51AM -0600, Joel A Fernandes wrote:
>> 
>> The problem being addressed is discussed in this thread:
>> http://permalink.gmane.org/gmane.linux.kernel/1389017
> 
> Thanks for the link.
> 
> Since the motivation is already documented in that post, why not add
> it into Documentation/devicetree/overlay-notes.txt as well?
> 
> Thanks,
> Richard
