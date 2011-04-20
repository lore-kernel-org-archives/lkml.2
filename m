Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1DTXq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:46:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408Ab1DTXqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:46:55 -0400
Date: Wed, 20 Apr 2011 16:46:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: james_p_freyensee@linux.intel.com
Cc: Greg KH <gregkh@suse.de>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
Message-Id: <20110420164621.3d817c4f.akpm@linux-foundation.org>
In-Reply-To: <1303341368.13457.92.camel@localhost>
References: <james_p_freyensee@linux.intel.com>
	<1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com>
	<alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com>
	<1303258222.13457.42.camel@localhost>
	<alpine.DEB.2.00.1104191817590.8047@chino.kir.corp.google.com>
	<20110420014340.GA21245@suse.de>
	<1303323083.13457.50.camel@localhost>
	<20110420191421.GA10306@suse.de>
	<20110420161125.3449d4fd.akpm@linux-foundation.org>
	<1303341368.13457.92.camel@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 16:16:08 -0700
J Freyensee <james_p_freyensee@linux.intel.com> wrote:

> On Wed, 2011-04-20 at 16:11 -0700, Andrew Morton wrote:
> > On Wed, 20 Apr 2011 12:14:21 -0700
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > > But as David pointed out, if there is work other than mine coming that
> > > > has already been proposed, wouldn't it be good to get this patch in
> > > > place now to start the encouragement of future eyes to just call this
> > > > function than re-invent the wheel?
> > > 
> > > No, then those projects submit the patch to export this, if they happen
> > > to get to mainline before this one does.
> > > 
> > > Again, don't export something unless you are using it at the time, no
> > > "this is to be used hopefully by something in the future" type stuff
> > > please.  Who knows if those future plans ever pan out.
> > 
> > Well there's an easy solution here.  Send the patch to export
> > get_task_comm(), then send along some patches which fix
> > 
> > z:/usr/src/linux-2.6.39-rc4> grep -r 'current->comm' drivers | wc -l
> > 89
> > 
> 
> Andrew, so does this mean you want me to send this patch to export
> get_task_comm() to you then?
> 

That works.  But Greg might see us doing it, so some additional
mergeable patches which *need* that export will keep him happy.

(iow, you're being extorted into doing some kernel cleanup work)
