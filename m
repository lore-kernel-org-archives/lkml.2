Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0EBUMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 16:12:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34650 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0EBUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 16:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T1jNBf/yG7ZKNCx+/sQ0p45PVRddFdNirHmKgllmXP0X1nC5GMzp00kQd7a5tMIKqC
         Z45GiYh5IBFtLHiKMjIZKpVMLQV1KssbX7ZB9S4+W4Or1jvh50aC4K3P76ZnuVvA1CRe
         /vOSc0w35BA0F/wTtezm1+YfYYSUiu94a+yeg=
Date: Mon, 3 May 2010 00:12:20 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Ryan Mallon <ryan@bluewatersys.com>,
       linux-kernel@vger.kernel.org, Yulia Vilensky <vilensky@compulab.co.il>
Subject: Re: [PATCH v3] ds2782_battery: add support for ds2786 battery gas
 gauge
Message-ID: <20100502201220.GA26113@oksana.dev.rtsoft.ru>
References: <1272279925-3122-1-git-send-email-mike@compulab.co.il>
 <20100426182200.GA18024@oksana.dev.rtsoft.ru>
 <p2qf870da181004261239r42aef5b1h2ae416712b465e2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p2qf870da181004261239r42aef5b1h2ae416712b465e2d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 10:39:41PM +0300, Mike Rapoport wrote:
> On Mon, Apr 26, 2010 at 9:22 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> >
> > Btw, I don't quite like the 'if (id->driver_data == 1)' stuff.
> > How about the following patch on top?
> >
> > From acf917d3880465b76875f671ee450a8fdff62c9f Mon Sep 17 00:00:00 2001
> > From: Anton Vorontsov <cbouatmailru@gmail.com>
> > Date: Mon, 26 Apr 2010 22:10:52 +0400
> > Subject: [PATCH] ds2782_battery: Get rid of magic numbers in driver_data
> >
> > Constructions like 'if (id->driver_data == 1)' look quite weird.
> > This patch introduces 'enum ds278x_num_id', which makes things
> > much more understandable, i.e. 'if (id->driver_data == DS2786)'.
> 
> agree
> 
> > Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> 
> Acked-by: Mike Rapoport <mike@compulab.co.il>

Thanks! Applied.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
