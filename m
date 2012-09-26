Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2IZQtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:49:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55970 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902Ab2IZQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:49:35 -0400
Date: Wed, 26 Sep 2012 17:49:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out
 common code
Message-ID: <20120926164932.GS4428@opensource.wolfsonmicro.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
 <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
 <20120925192048.GA17038@sirena.org.uk>
 <20120926145615.GJ10147@mail.gnudd.com>
 <20120926150429.GQ4428@opensource.wolfsonmicro.com>
 <20120926163145.GK10147@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926163145.GK10147@mail.gnudd.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 06:31:45PM +0200, Davide Ciminaghi wrote:

> Oh, and there's another problem (I'm looking at the code right now, I had
> forgotten about this): the clock framework also asks for a spinlock_t *.
> Regmap has its own spinlock (or mutex), and I don't think it would be a
> good idea trying to export it.

Why is this a problem?  Nested spinlocks are perfectly fine.
