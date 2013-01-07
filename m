Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3AGVfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:35:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3AGVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:35:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Date: Mon, 7 Jan 2013 21:35:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com> <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com> <20130107210551.GL14149@atomide.com>
In-Reply-To: <20130107210551.GL14149@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301072135.05166.arnd@arndb.de>
X-Provags-ID: V02:K0:Pi1d6CEc1k1zNiAt9z+FgKGbrRV0Z6q1XlFO+SrnwZB
 mfjJrKCiPzBsICZI8DJiGc99c+46CE8HnpC8lqnY2joRZ0/99D
 Ajfh6ebqZm5jq+N3LGbcQOXAwGLGTVY53PzY7c8xdnRvTsimZ4
 eWnatI8PXBSqssInSAdGTShseTp/jnLNugG3hqXg6HQcs/uDCx
 ac4ePEz9kjr61twN/n0y/I0b4ea8BtHoClPZVbS9yWdcpHbKZT
 bg3EDa22Wb2VtMoxocsM5yqamhvSNP8+PEYiovOOhyrGdbXeOs
 G5aLYtLQLzLrXQk/QaLoNXPA9p5C3NCq1mxx2dZAh4CywbPHBQ
 P2sFyMXB6n8FrnCZXRt8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Sascha Hauer, Linus Walleij, Lee Jones to Cc)

On Monday 07 January 2013, Tony Lindgren wrote:
> > 
> > At the end of the line, some kind of hardware glue is going to be needed.
> > 
> > I just feel that drawing from a sample size of 1 (maybe 2 if I get to throw
> > in the beagleboard), it is a bit premature to think about making it overly
> > general, besides the part that are obviously part of the infrastructure 
> > (like the DT overlay stuff).
> > 
> > What I'm getting at, is that we need some user experience about this, before
> > going away and creating structure out of possible misconception about the uses. 
> 
> IMHO stuff like this will be needed by many SoCs. Some examples of similar
> things for omaps that have eventually become generic frameworks have been
> the clock framework, USB OTG support, runtime PM, pinmux framework and
> so on.
> 
> So I suggest a minimal generic API from the start as that will make things
> a lot easier in the long run.

I agree. The ux500 platform already has the concept of "user interface boards",
which currently is not well integrated into devicetree. I believe Sascha
mentioned that Pengutronix had been shipping some other systems with add-on
boards and generating device tree binaries from source for each combination.

Ideally, both of the above should be able to use the same DT overlay logic
as BeagleBone, and I'm sure there are more of those.

	Arnd
