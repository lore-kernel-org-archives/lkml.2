Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2A3Ukt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:40:49 -0500
Received: from [206.117.179.246] ([206.117.179.246]:38947 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023Ab2A3Ukr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:40:47 -0500
Message-ID: <1327956028.25132.53.camel@joe2Laptop>
Subject: Re: [PATCH 3/5] staging: tidspbridge: Lindent to drv_interface.c
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?V=EDctor?= "M." =?ISO-8859-1?Q?J=E1quez?= "L." 
	<vjaquez@igalia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>,
        Armando Uribe <x0095078@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Date: Mon, 30 Jan 2012 12:40:28 -0800
In-Reply-To: <20120130203312.GA3296@lit.local.igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
	 <7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
	 <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
	 <20120130192907.GX3294@mwanda> <1327953180.25132.39.camel@joe2Laptop>
	 <20120130203312.GA3296@lit.local.igalia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 21:33 +0100, Víctor M. Jáquez L. wrote:
> On Mon, Jan 30, 2012 at 11:53:00AM -0800, Joe Perches wrote:
> > I've done a patch here to tidspbridge that standardizes
> > printk output.
> > 
> > Basically, the patch adds
> > #define pr_fmt(fmt) KBUILD_MODNAME "%s: ", __func__
> > to prefix "tidspbridge:%s:", removes the leading
> > "%s:...",  __func__ from the uses, coalesces
> > formats and does argument alignment.
> > 
> > It cleans up the DBC_ASSERT, DBC_REQUIRE and DBC_ENSURE
> > macros too.
> 
> hehehe... I also have one for this... But I prefer yours: I'm a newbie :)

Well, given that you haven't done many of these, I prefer yours.


