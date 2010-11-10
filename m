Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0KJSkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:40:08 -0500
Received: from kroah.org ([198.145.64.141]:46737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0KJSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:40:07 -0500
Date: Wed, 10 Nov 2010 10:39:40 -0800
From: Greg KH <greg@kroah.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
Message-ID: <20101110183940.GA15089@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com> <20101109224450.GB21992@kroah.com> <AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:53:37AM +0600, Rakib Mullick wrote:
> On Wed, Nov 10, 2010 at 4:44 AM, Greg KH <greg@kroah.com> wrote:
> >
> > If it's really not used then why would marking it inline help out any?
> > Shouldn't we just delete the function instead?
> >
> As far as I can see, its been called recursively and also from
> sysfs_add_one. Am I missing anything?

If so, then what is the compiler warning that is being generated that
you are trying to resolve?

totally confused,

greg k-h
