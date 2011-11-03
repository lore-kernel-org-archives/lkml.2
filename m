Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1KCBcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:32:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1KCBcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:32:10 -0400
Date: Wed, 2 Nov 2011 18:29:29 -0700
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
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v2 3/3] param: make /sys/module/*/paramaters optional
Message-ID: <20111103012929.GA3449@suse.de>
References: <cover.1320191327.git.david.decotigny@google.com>
 <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
 <20111102002412.GA14977@suse.de>
 <CAG88wWaZZj8k4KmgHdtYUiWQRcVTOaBDS0ik3bqj+VXzm5SQjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG88wWaZZj8k4KmgHdtYUiWQRcVTOaBDS0ik3bqj+VXzm5SQjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 04:02:24PM -0700, David Decotigny wrote:
> Thank you all for your feedback.
> 
> FYI, this patch was meant to be an answer to a negative feedback I
> received when I proposed changing a few module_param(... perm=S_IRUGO)
> in forcedeth driver. But I agree the "price to pay" is very low.

Who gave you complaints about that?  Really?

> Should I drop this patch?

Please do.

greg k-h
