Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1GENhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:37:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GENhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:37:47 -0400
Date: Tue, 5 Jul 2011 06:26:29 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH] firmware: gsmi: remove sysfs entries when unload the
 module
Message-ID: <20110705132629.GC8061@suse.de>
References: <1309334273.6368.1.camel@phoenix>
 <CAGTjWtCzC=bZue1g885cmkH-EHKFb4Lf=JqoyP5QQz2b=xOdEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGTjWtCzC=bZue1g885cmkH-EHKFb4Lf=JqoyP5QQz2b=xOdEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 11:46:20AM -0700, Mike Waychison wrote:
> On Wed, Jun 29, 2011 at 12:57 AM, Axel Lin <axel.lin@gmail.com> wrote:
> >
> > This patch removes sysfs entries in gsmi_exit() and gsmi_init() error path.
> >
> > Also move the driver successfully loaded message to the end of gsmi_init()
> > and return proper error if register_efivars() fails.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mike Waychison <mikew@google.com>
> 
> Greg, can you pick this up in drivers-core?

I already did last week :)
