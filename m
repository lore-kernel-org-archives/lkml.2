Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab0I0OEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:04:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54200 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753136Ab0I0OEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:04:24 -0400
Date: Mon, 27 Sep 2010 16:04:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: ext Andy Isaacson <adi@hexapodia.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@kernel.org" <akpm@kernel.org>
Subject: Re: [PATCH RFC 1/1] MISC: Broadcom BCM4751 GPS driver
Message-ID: <20100927140412.GA3277@ucw.cz>
References: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1283512047.26985.119.camel@masi.mnp.nokia.com>
 <20100910185942.GB17794@hexapodia.org>
 <1284372716.12913.25.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284372716.12913.25.camel@masi.mnp.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-09-13 13:11:56, Matti J. Aaltonen wrote:
> On Fri, 2010-09-10 at 20:59 +0200, ext Andy Isaacson wrote:
> > On Fri, Sep 03, 2010 at 02:07:27PM +0300, Matti J. Aaltonen wrote:
> > > On Mon, 2010-08-23 at 16:00 +0200, Aaltonen Matti.J (Nokia-MS/Tampere)
> > > wrote:
> > > > Driver for Broadcom BCM4751 GPS chip.
> > > 
> > > I sent this a while ago but didn't get any comments about the code. What
> > > do you think should something be changed or is it ready to get accepted?
> > 
> > It's unlikely to get merged if there's no public documentation of the
> > protocol it exposes, and no free codebase using the interface.
> 
> OK... I'll just mention once again that it's possible to get the
> specification for free after signing a contract with Nokia. (See:

And you can get review comments after signing contract with me.

Andy said it nicely in the other mail. No undocumented kernel
interfaces please.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
