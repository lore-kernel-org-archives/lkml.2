Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0H3PTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:19:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34849 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0H3PTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dlJRnwOAO87Dm1QEbixt8a5Lqsq2yUPBbyaTiAOco01SMj2DaSvczlhKsCHJwzeTgC
         /aO8RXl3ALkn8b3V5GjUmZXticK/bFC2Gn8w311Z71ueB6OFwGwnqtvUgR2+KfKLpQ+r
         L5X0S+hSUqnNl1yI5BncctxRgzCnKhPe5JjPk=
MIME-Version: 1.0
In-Reply-To: <20100830114031.69889a6f@notabene>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	<1282837904.1875.64.camel@Joe-Laptop>
	<20100826161451.GB2367@linux.vnet.ibm.com>
	<1282839933.8133.11.camel@mulgrave.site>
	<20100826165044.GE2367@linux.vnet.ibm.com>
	<20100826230021.GA4098@xanatos>
	<20100826232323.GL2367@linux.vnet.ibm.com>
	<20100830114031.69889a6f@notabene>
Date: Mon, 30 Aug 2010 10:19:05 -0500
Message-ID: <AANLkTi=YHaebs5_VB5-zxgKv187rica6AA_X4xZ6sEi5@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Joe Perches <joe@perches.com>, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 8:40 PM, Neil Brown <neilb@suse.de> wrote:
>
> The idea that appeals to me is for the 'todo list' URL to be an RSS feed, and
> we have some site that automagically extracts all the todo lists and creates
> a todo planet.  (todo.kernelplanet.org ??)
> Then interested parties could subscribe to that and watch the ideas go by.
>
> But getting a useful subset of maintainers to put a todo list in an RSS feed
> feels somewhat like herding wild-cats...
>

I think the best approach would be to start doing it and hope others
follow suit.

What would the standard template be for something like this?  Would we
just stick to title, link, description?

      -eric
