Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1E0PNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:13:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32934 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1E0PNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nTjW1Jj69AyUrf/nl5+4mzOVVgVIddXs7+37J4ZS8tiTVKelvnrO6mZ808KvyDY4kD
         OCxLZP/b5wiU97kbThAe+eWirqXbLJ23QQvAFRkgq15hxlQcq19HPOY0oYFz0wbrQeLi
         l8QtJfDV2M56UG2G8qdv4rhcMItKb5n9csgvo=
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
From: Namhyung Kim <namhyung@gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
	 <20110527131237.GA27647@infradead.org>
	 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 00:13:02 +0900
Message-ID: <1306509182.1351.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-27 (금), 09:57 -0400, Mike Snitzer:
> On Fri, May 27, 2011 at 9:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, May 27, 2011 at 10:11:22PM +0900, Namhyung Kim wrote:
> >> Since BARRIER requests have been converted to FLUSH/FUA, it would be
> >> better for blktrace to recognize FLUSH requests as BARRIER for the
> >> backward-compatibility IMHO.
> >
> > I'd rather see new flags for them.  F and U maybe?
> 
> Somehow I'm not surprised by your F and U suggestion -- appropriate on
> multiple levels :)

OK. I'll work on that direction.
Thanks.


-- 
Regards,
Namhyung Kim


