Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1DSErH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 00:47:07 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:42650 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750739Ab1DSErF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 00:47:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NarIriB4fHQC14bVy0nhjqBD+V+S52D0UtTY4UjV0UVJB0cc9W7BJm7DLyu7/bovzO6DSMAaW3pPnsXhjBpbSSt8W+XNCtXHVebW3OqccK0lGoyxLHxa0Z/F37Bb2w6x;
Date: Mon, 18 Apr 2011 21:47:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Mundt <lethal@linux-sh.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Prokop <mika@grml.org>
Subject: Re: [PATCH] Documentation/dontdiff: large update
Message-Id: <20110418214702.8e610b47.rdunlap@xenotime.net>
In-Reply-To: <20110419024030.GA28271@linux-sh.org>
References: <20110418160809.f10c0b62.rdunlap@xenotime.net>
	<20110419024030.GA28271@linux-sh.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 11:40:30 +0900 Paul Mundt wrote:

> On Mon, Apr 18, 2011 at 04:08:09PM -0700, Randy Dunlap wrote:
> > -int16.c
> > -int1.c
> > -int2.c
> > -int32.c
> > -int4.c
> > -int8.c
> > +int*.c
> 
> int[0-9]*.c or something might make sense, but this is going to trip up a
> lot of intel and interrupt related files.
> 
> > +lib1funcs.S
> 
> This is also bogus. The one place it's used in a .gitignore in the kernel
> is a special case, while you obviously don't want to ignore it in the
> arch/foo/lib/ case.

Thanks, Paul.  I'll correct those and repost the patch.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
