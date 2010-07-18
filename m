Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0GRJV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 05:21:58 -0400
Received: from THUNK.ORG ([69.25.196.29]:51708 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0GRJVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 05:21:55 -0400
Date: Sun, 18 Jul 2010 05:21:48 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        linux-kernel@vger.kernel.org, Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
Message-ID: <20100718092148.GD4684@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dimitrios Apostolou <jimis@gmx.net>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
	Dan Nicolaescu <dann@gnu.org>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
 <m3tyny31mo.fsf@intrepid.localdomain>
 <20100717065146.732f5449.rdunlap@xenotime.net>
 <20100718071552.GB4684@thunk.org>
 <alpine.LNX.2.00.1007181149560.3666@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1007181149560.3666@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 12:10:09PM +0300, Dimitrios Apostolou wrote:
> 
> FWIW that way will show the parameters unaligned to anyone using a
> different tab length. There is one way to align such lines properly:

As Randy said, the One True Tab Stop Length is 8.  I don't think
that's going to change anytime soon.  You might as well complain that
things don't look right if you like to use a font with variable width
characters...

					- Ted
