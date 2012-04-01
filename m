Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2DAXSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 19:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2DAXSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 19:18:11 -0400
Date: Mon, 2 Apr 2012 01:17:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: fix the usage of kthread_stop()
Message-ID: <20120401231741.GA24480@redhat.com>
References: <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com> <20110920143942.GB15859@redhat.com> <20110920151410.GA16569@redhat.com> <20110920183810.GA25159@suse.de> <20120306173925.GA17551@redhat.com> <20120306193040.GD21503@distanz.ch> <20120308185739.GA18935@redhat.com> <20120313114512.GM21503@distanz.ch> <20120313180718.GA9224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313180718.GA9224@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Oleg Nesterov wrote:
>
> On 03/13, Tobias Klauser wrote:
> >
> > Looks OK to me at a first glance. I'll try to dig up my test system
> > where I was able to produce that NULL pointer dereference and test your
> > patch there and will then let you know my results.
>
> Oh, great. Please find the patch below.
>
> Of course it wasn't tested at all ;)

Cough... Sorry, but another ping ;)

Oleg.

