Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab2DBILg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:11:36 -0400
Received: from sym2.noone.org ([178.63.92.236]:57283 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2DBILe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:11:34 -0400
Date: Mon, 2 Apr 2012 10:11:30 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: fix the usage of kthread_stop()
Message-ID: <20120402081130.GZ21503@distanz.ch>
References: <20110920143920.GA15859@redhat.com>
 <20110920143942.GB15859@redhat.com>
 <20110920151410.GA16569@redhat.com>
 <20110920183810.GA25159@suse.de>
 <20120306173925.GA17551@redhat.com>
 <20120306193040.GD21503@distanz.ch>
 <20120308185739.GA18935@redhat.com>
 <20120313114512.GM21503@distanz.ch>
 <20120313180718.GA9224@redhat.com>
 <20120401231741.GA24480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401231741.GA24480@redhat.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-02 at 01:17:41 +0200, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/13, Oleg Nesterov wrote:
> >
> > On 03/13, Tobias Klauser wrote:
> > >
> > > Looks OK to me at a first glance. I'll try to dig up my test system
> > > where I was able to produce that NULL pointer dereference and test your
> > > patch there and will then let you know my results.
> >
> > Oh, great. Please find the patch below.
> >
> > Of course it wasn't tested at all ;)
> 
> Cough... Sorry, but another ping ;)

I currently don't have the test system at hand (I'm not on this project
anymore), so it might take a while until I get to it, sorry.

Tobias
