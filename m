Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab1DSEqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 00:46:42 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60084 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750739Ab1DSEqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 00:46:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sSZHFfFtA1olLyyvdLjUd6tqdmcxPpAtuUGcRapHS2zBrh/VQWDEDZ/WrWvgV9s7YXYJ7xxD46mcDEsMeCZOYV4jA9iMUuw3c0U2o+d999//c2r3xQU8hrEdYf+fEUpa;
Date: Mon, 18 Apr 2011 21:46:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Prokop <mika@grml.org>
Subject: Re: [PATCH] Documentation/dontdiff: large update
Message-Id: <20110418214637.88f5bd3d.rdunlap@xenotime.net>
In-Reply-To: <1303176177.31723.58.camel@Joe-Laptop>
References: <20110418160809.f10c0b62.rdunlap@xenotime.net>
	<1303176177.31723.58.camel@Joe-Laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 18:22:57 -0700 Joe Perches wrote:

> On Mon, 2011-04-18 at 16:08 -0700, Randy Dunlap wrote:
> > Update to Documentation/dontdiff, based on many updates to
> > various .gitignore patches over the last 2 years.
> []
> > --- lnx-2639-r3g8-dontdiff.orig/Documentation/dontdiff
> > +++ lnx-2639-r3g8-dontdiff/Documentation/dontdiff
> []
> > -int16.c
> > -int1.c
> > -int2.c
> > -int32.c
> > -int4.c
> > -int8.c
> > +int*.c
> 
> Is this really a good idea?
> 
> $ find -name "int*.c" | wc -l
> 115

Thanks for the feedback.  Will fix & repost.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
