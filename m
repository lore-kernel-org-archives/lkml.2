Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1KBAYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 20:24:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1KBAYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 20:24:44 -0400
Date: Tue, 1 Nov 2011 17:24:12 -0700
From: Greg KH <gregkh@suse.de>
To: David Decotigny <david.decotigny@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>,
        David Decotigny <decot@google.com>
Subject: Re: [PATCH v2 3/3] param: make /sys/module/*/paramaters optional
Message-ID: <20111102002412.GA14977@suse.de>
References: <cover.1320191327.git.david.decotigny@google.com>
 <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:50:35PM -0700, David Decotigny wrote:
> From: David Decotigny <decot@google.com>
> 
> With this patch, we allow systems that don't want to pay the price for
> /sys/module/*/paramaters to be compiled without that feature.

The "price"?  What kind of price is it?  How much memory is really saved
here?

greg k-h
