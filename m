Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549Ab2K3PD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:03:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030520Ab2K3PDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:03:54 -0500
Date: Fri, 30 Nov 2012 10:03:46 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cifs: Make CIFS_DEBUG possible to undefine
Message-ID: <20121130100346.0aa9cabd@tlielax.poochiereds.net>
In-Reply-To: <1354287129.11903.3.camel@joe-AO722>
References: <cover.1354217746.git.joe@perches.com>
	<26f6f4e1a1fb5091784fb1a6919e214994a6dc88.1354217746.git.joe@perches.com>
	<20121130064919.373547f4@tlielax.poochiereds.net>
	<1354287129.11903.3.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 06:52:09 -0800
Joe Perches <joe@perches.com> wrote:

> On Fri, 2012-11-30 at 06:49 -0500, Jeff Layton wrote:
> > On Thu, 29 Nov 2012 11:37:19 -0800
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > Make the compilation work again when CIFS_DEBUG is not #define'd.
> > > 
> > > Add format and argument verification for the various macros when
> > > CIFS_DEBUG is not #define'd.
> []
> > Would it be better to simply make those the standard
> > 
> > "do { ; } while(0)" noop macros?
> > 
> > I'm not sure I see the point in keeping the printk statements in there...
> 
> Actually, that's not standard.
> Look at printk.h
> 
> It prevents developers from adding code that compiles
> without warnings in one mode but compiles with warnings
> in another.
> 
> The idea is to make sure that format and arguments always
> match regardless of whether or not you are compiling
> debug or non-debug.
> 
> 

Fair enough then...

Reviewed-by: Jeff Layton <jlayton@redhat.com>
