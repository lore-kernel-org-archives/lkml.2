Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1KOWVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:21:31 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64976 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1KOWVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:21:30 -0500
Date: Tue, 15 Nov 2011 23:21:19 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: balbi@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111115222119.GA17953@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20111115220437.GA26711@legolas.emea.dhcp.ti.com>
References: <20111115220437.GA26711@legolas.emea.dhcp.ti.com>
  <20111115212012.GA5467@suse.de>  <20111115130230.GA23584@mail.gnudd.com>
  <20111115213734.GA5094@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this will be useful to dwc3 too, we currently have:
> [...]

Yes, this is similar, just factorized for everybody to use. I looked
for files that may use it (besides stuff I received internally) by
counting the %08x.

So in V2, tomorrow, I'll port your file to use the centralized code
tool, as a separate patch.

thank your for your interest
/alessandro
