Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0GLVsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:48:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0GLVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:48:00 -0400
Date: Mon, 12 Jul 2010 23:47:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, yehuda@hq.newdream.net
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Message-ID: <20100712214754.GC17978@basil.fritz.box>
References: <201007011744.19564.trenn@suse.de>
 <201007091303.08693.trenn@suse.de>
 <20100709133019.GA2856@redhat.com>
 <201007121624.17543.trenn@suse.de>
 <20100712162140.GA2925@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712162140.GA2925@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 12:21:40PM -0400, Jason Baron wrote:
> On Mon, Jul 12, 2010 at 04:24:16PM +0200, Thomas Renninger wrote:
> > Hi,
> > 
> > it's this one:
> > commit ff49d74ad383f54041378144ca1a229ee9aeaa59
> > Author: Yehuda Sadeh <yehuda@hq.newdream.net>
> > Date:   Sat Jul 3 13:07:35 2010 +1000
> > 
> > which touches same code than Jason's fix does.
> > Possibly this patch also addresses (only parts of?) this problem?
> > Jason: Do you mind having a look at the latest git version and review
> > Yehuda's  and adjust your patch if still necessary.
> 
> So Yehuda's patch is meant to address this issue. I would still move the
> remove code to free_module(), for the case that load_module() fails as
> follows (on top of Yehuda's patch):

One of the known failures with this was a module that was just missing its exit
function, but otherwise working. Is the patch likely to address this
too? 

-Andi

