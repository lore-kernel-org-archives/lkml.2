Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0IGVfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:35:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:41087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab0IGVfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:35:37 -0400
Date: Tue, 7 Sep 2010 14:29:15 -0700
From: Greg KH <gregkh@suse.de>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: Maxim Osipov <maxim.osipov@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
Message-ID: <20100907212915.GB6798@suse.de>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com> <5A47E75E594F054BAF48C5E4FC4B92AB03291AE03E@dbde02.ent.ti.com> <20100906201852.GB5162@suse.de> <4C860C21.40708@ru.mvista.com> <AANLkTins336XV97o=72YdqLf1Gr_hA9NjMNqcaWDosfK@mail.gmail.com> <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 04:18:23PM +0530, Gadiyar, Anand wrote:
> Since Greg has already sent a pull request, I won't touch the file
> now; maybe a trivial patch later on to fix up the coding style.

That would be fine to have, I'd gladly accept it.

thanks,

greg k-h
