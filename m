Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab1FARrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:47:17 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47481 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab1FARrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=kepstin.ca; s=google;
        h=subject:from:to:cc:date:in-reply-to:references:content-type
         :x-mailer:content-transfer-encoding:message-id:mime-version;
        b=Zf5/6A+vqv34ujfymrUHVYFO8S8ipIT+c3OzFKg0uORstLvSy+O6YLb5qcCSArWYSq
         Jgb4hSTeRK0zyU9CmWeFemFiZd1RJYWZFz2qditeGnXj/9cch9fIt4oZCp0uKISiF31U
         RfqrgLAlOYw31cQWqHnzNgOWtyT+TE+pGxq8g=
Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Willy Tarreau <w@1wt.eu>
Cc: Joe Pranevich <jpranevich@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 01 Jun 2011 13:47:12 -0400
In-Reply-To: <20110531201348.GA8723@1wt.eu>
References: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
	 <BANLkTi=w7VhV2GxKrGGe9dirHcEkwKrDwA@mail.gmail.com>
	 <BANLkTim7XZKLCRp=ZtRJWhi7k4BzwYpRpg@mail.gmail.com>
	 <20110531201348.GA8723@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 
Content-Transfer-Encoding: 7bit
Message-ID: <1306950434.3627.23.camel@ayu>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 22:13 +0200, Willy Tarreau wrote:
> On Tue, May 31, 2011 at 01:22:49AM -0400, Joe Pranevich wrote:
> > Mike,
> > 
> > Thank you. I appreciate the comments and the corrections. It was a
> > marathon weekend and yes, I missed some obvious typos. Thanks.
> > 
> I'd say that in general, almost all of the features you're announcing as
> "new" will make unaware people think that older versions did not have
> those features, which is quite misleading. Linus took great care to say
> that 3.0-rc1 had very few changes, it can be a bit confusing to see a
> post pretending it to be a revolutionary new kernel.
> 
> Probably that you should more clearly say that all those features were
> progressively added in all 2.6 releases, otherwise I'm already expecting
> to see a lot of idiocies posted in journals.

Perhaps a simple change of the title and introduction would handle
clearing this up. Instead of presenting it as a "What's new in Linux
3.0" article (which it is not, or it would be a lot shorter!), why not
call it what it actually is: "A Retrospective of the Linux 2.6 era"?

-- 
Calvin Walton <calvin.walton@kepstin.ca>

