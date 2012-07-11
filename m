Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2GKIMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:12:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2GKIMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:12:47 -0400
Date: Wed, 11 Jul 2012 01:15:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind1@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2012-07-10-16-59 uploaded
Message-Id: <20120711011538.cfc01e20.akpm@linux-foundation.org>
In-Reply-To: <1341994106.2963.138.camel@sauron>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
	<1341988680.2963.128.camel@sauron>
	<20120711004430.0d14f0b6.akpm@linux-foundation.org>
	<1341993193.2963.132.camel@sauron>
	<20120711005926.25acc6c6.akpm@linux-foundation.org>
	<1341994106.2963.138.camel@sauron>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 11:08:26 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Wed, 2012-07-11 at 00:59 -0700, Andrew Morton wrote:
> > > > I looked at them, but they're identical to what I now have, so nothing
> > > > needed doing.
> > > 
> > > Strange, I thought they had the white-spaces issue solved. 
> > 
> > They did, but I'd already fixed everything.  That's what those emails
> > in your inbox were about.
> 
> Sorry Andrew, you did not squash your changes in, and your fix-up patch
> did not have a nice commit message last time I looked, which made me
> think that it is temporary and you expect an updated version of my
> patches.

I don't fold patches together until immediately prior to sending them
to someone else, or dropping them.


