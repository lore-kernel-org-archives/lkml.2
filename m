Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0D1PBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:01:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0D1PBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:01:39 -0400
Date: Wed, 28 Apr 2010 07:44:30 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Rankilor <reodge@gmail.com>
Cc: Sven Eckelmann <sven.eckelmann@gmx.de>, andrew@lunn.ch,
       lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: batman-adv: fixed comments to maintain 80
	char limit
Message-ID: <20100428144430.GA18945@suse.de>
References: <1272361449-15416-1-git-send-email-reodge@gmail.com> <201004271153.34972.sven.eckelmann@gmx.de> <p2p90c96c971004280633t1188db65pd1bbe3679adf4d53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2p90c96c971004280633t1188db65pd1bbe3679adf4d53@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 09:33:40PM +0800, Mark Rankilor wrote:
> On 27 April 2010 17:53, Sven Eckelmann <sven.eckelmann@gmx.de> wrote:
> > Your patch doesn't apply anymore. See
> > 1270341625-28764-1-git-send-email-luisbg@ubuntu.com and follow ups [1].
> 
> I had a look at the follow ups and saw this one:
> 
> https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2010-April/002483.html
> 
> So would it be best if I were to submit patches against the linux-next
> tree? Or is it necessary to work against the batman maint or master
> trees?
> 
> I'd much prefer if I could work against linux-next since if I wanted
> to do some work on another staging driver, then I wouldn't have to go
> and check out their repository.

Please work against linux-next, it is up to the batman developers to
also work against linux-next as well.  That levels the playing field for
everyone involved.

thanks,

greg k-h
