Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab0KQKDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:03:43 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37804 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932798Ab0KQKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:03:42 -0500
Date: Wed, 17 Nov 2010 11:03:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
Message-ID: <20101117100321.GB1574@ucw.cz>
References: <1289273338.6287.128.camel@dan>
 <20101109120649.62b487e8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109120649.62b487e8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-09 12:06:49, Alan Cox wrote:
> On Mon, 08 Nov 2010 22:28:58 -0500
> Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > The kernel syslog contains debugging information that is often useful
> > during exploitation of other vulnerabilities, such as kernel heap
> > addresses.  Rather than futilely attempt to sanitize hundreds (or
> > thousands) of printk statements and simultaneously cripple useful
> > debugging functionality, it is far simpler to create an option that
> > prevents unprivileged users from reading the syslog.
> 
> Except for anything that appears on the screen - which is remotely
> readable via the screen access APIs. Looks sane to me (pointless but
> sane) and the checks match the ones needed to redirect the console so you
> need CAP_SYS_ADMIN either way.

/dev/vcsa is only protected by filesystem permissions IIRC.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
