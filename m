Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1EORfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:35:33 -0400
Received: from kroah.org ([198.145.64.141]:55256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1EORfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:35:32 -0400
Date: Sun, 15 May 2011 10:36:44 -0700
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>,
        devel@driverdev.osuosl.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] Add ST-Ericsson CG2900 driver
Message-ID: <20110515173644.GA18241@kroah.com>
References: <1305040215-712-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <BANLkTinAtUQ8H1DQpqXxX_U4mLO617L3Eg@mail.gmail.com>
 <20110515163257.GE1315@kroah.com>
 <BANLkTi=hN6NeLdXAjzeeYwcZR7+BoJ1BQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=hN6NeLdXAjzeeYwcZR7+BoJ1BQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 07:29:04PM +0200, Linus Walleij wrote:
> It was my recommendation to put it into staging, by doing this
> people can talk about the architecture by submitting *patches*
> to show how they want it instead of these fruitless discussions.
> 
> So this should be a case where staging really helps, at least in
> my dreams.

Yes, that is where staging should help, hopefully we can get these build
dependancies worked out to get this merged properly.  Perhaps for the
.41 merge window?

thanks,

greg k-h
