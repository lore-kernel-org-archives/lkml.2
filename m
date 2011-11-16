Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1KPLbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:31:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49758 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab1KPLbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:31:52 -0500
Date: Wed, 16 Nov 2011 11:31:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111116113147.GB773@sirena.org.uk>
References: <20111115130230.GA23584@mail.gnudd.com>
 <20111115212012.GA5467@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115212012.GA5467@suse.de>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:20:12PM -0800, Greg KH wrote:
> On Tue, Nov 15, 2011 at 02:02:30PM +0100, Alessandro Rubini wrote:

> > Some debugfs file I deal with are mostly blocks of registers,
> > i.e. lines of the form "<name> = 0x<value>". Some files are only
> > registers, some include registers blocks among other material.  This
> > patch introduces data structures and functions to deal with both
> > cases.  I expect more users of this over time.

> Nice, but a few minor questions:

Hrm, we have something similar in regmap but in the form

number: value

Might be worth looking at that for the seeking implementation, or to
suggest improvements to the regmap one.
