Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0JEHXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:23:22 -0400
Received: from ist.d-labs.de ([213.239.218.44]:38496 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0JEHXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:23:21 -0400
Date: Tue, 5 Oct 2010 09:23:19 +0200
From: Florian Mickler <florian@mickler.org>
To: Greg KH <greg@kroah.com>
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.virtualization
Cc: Hank Janssen <hjanssen@sailtheuniverse.com>, hjanssen@microsoft.com,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: hv: Remove camel case variables in
 channel.c
Message-ID: <20101005092319.7ae2ba86@schatten.dmk.lab>
In-Reply-To: <20100930121210.GA14358@kroah.com>
References: <4CA4105E.80602@sailtheuniverse.com>
	<20100930121210.GA14358@kroah.com>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 05:12:10 -0700
Greg KH <greg@kroah.com> wrote:

> On Wed, Sep 29, 2010 at 09:21:50PM -0700, Hank Janssen wrote:
> > 
> > Rename camel case variables in channel.c and changed them to
> > lowercase.
> > 
> > Sending this from my own accounts till we have a proper mail server
> > set up that allows us to send out patches without issues.
> 
> This paragraph goes below the '---' line, it doesn't belong in the
> change log, right?


I recently read something about 'scissor lines' which allow more
natural reading flow with patches by git automatically skipping
everything above a scissor-line:
'A line that mainly consists of scissors (either ">8" or "8<") and 
perforation (dash "-") marks is called a scissors line'

man git-mailinfo
git-am -c

:-)

Cheers,
Flo
