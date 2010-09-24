Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0IXS1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:27:54 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:32823 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756389Ab0IXS1w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:27:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CCkdzHRHN/bWdd+hgzaV/8x1NZzPkOnFLGQihmOzk8rvCtUxVsdxUlcaU3rAmRsKJyfuuhStKp22tPacLXCNXYuGzE4GruqAfTfo0BedWdaz6GnXCoNYKxPAjHO5EXOi;
Date: Fri, 24 Sep 2010 11:27:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/4] resources: ensure alignment callback doesn't
 allocate below available start
Message-ID: <20100924112748.3b784624@jbarnes-desktop>
In-Reply-To: <AANLkTikiEsqReicJxurQXf7GghKQjJ3agooefs59eULC@mail.gmail.com>
References: <20100917223109.24687.17697.stgit@bob.kio>
	<20100917223212.24687.3519.stgit@bob.kio>
	<20100924100733.2e7fa2ac@jbarnes-desktop>
	<AANLkTikiEsqReicJxurQXf7GghKQjJ3agooefs59eULC@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 11:15:54 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Sep 24, 2010 at 10:07 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Applied this series.  It's way bigger than I'd like at this point, but
> > it does fix some regressions, so I'll give Linus the option of pulling
> > it in my next pull request.  If he declines, we'll put it into -next
> > and tag it for inclusion into the stable series.
> 
> I definitely am not going to pull this series for 2.6.36.
> 
> I could possibly take this first one that only prepares for the real
> change and doesn't actually change anything in itself, but switching
> around the order of allocations after -rc5 would be crazy. Yes, it may
> help some people, but we have absolutely no idea who it could hurt. So
> the whole thing is definitely something for the merge window (and
> preferably pretty early there too)

Ok that's settled then (though I was secretly hoping you'd pull &
then release 2.6.36 without even compile testing).

It's all ready and queued up, I'll send you a pull request early on so
we can get some good test coverage.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
