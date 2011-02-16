Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab1BPH4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:56:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:54922 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751631Ab1BPH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:56:50 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19aZ0dXH/Rao2HJa/sFeT+pdftUO7lpVH17hsvjFG
	PegUQMTAXQWd02
Subject: Re: [114/115] sched: Remove  some dead code
From: Mike Galbraith <efault@gmx.de>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kay Sievers <kay.sievers@vrfy.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110216073701.GS4384@bicker>
References: <20110216014741.GA24678@kroah.com>
	 <20110216014705.654816731@clark.kroah.org>  <20110216073701.GS4384@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 08:56:44 +0100
Message-ID: <1297843004.8874.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 10:37 +0300, Dan Carpenter wrote:
> On Tue, Feb 15, 2011 at 05:46:20PM -0800, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > 
> > From: Dan Carpenter <error27@gmail.com>
> > 
> > commit 618765801ebc271fe0ba3eca99fcfd62a1f786e1 upstream.
> > 
> > This was left over from "7c9414385e sched: Remove USER_SCHED"
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> This is just a cleanup patch.  It doesn't really warrant backporting.

There's no reason to leave the dirt lying about though.

	-Mike

