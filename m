Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0IFUt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:49:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0IFUtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:49:52 -0400
Date: Mon, 6 Sep 2010 13:18:52 -0700
From: Greg KH <gregkh@suse.de>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: Maxim Osipov <maxim.osipov@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
Message-ID: <20100906201852.GB5162@suse.de>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com> <5A47E75E594F054BAF48C5E4FC4B92AB03291AE03E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03291AE03E@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 08:07:31PM +0530, Gadiyar, Anand wrote:
> Maxim Osipov wrote:
> > Hello,
> > 
> > Please find attached patch for
> > https://bugzilla.kernel.org/show_bug.cgi?id=16023 problem.
> > 
> 
> Looks like this is already in greg's tree, but the patch has
> checkpatch errors.
> 
> (Caught by an autobuild tool we're playing with).
> 
> @Greg,
> Would you like an updated patch fixing them?

Please, that would be great.

thanks,

greg k-h
