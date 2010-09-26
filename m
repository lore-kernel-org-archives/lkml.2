Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0IZCpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 22:45:35 -0400
Received: from mail.perches.com ([173.55.12.10]:2426 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0IZCpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 22:45:34 -0400
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andy Whitcroft <apw@canonical.com>, Christoph Hellwig <hch@lst.de>,
        T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca, jack@suse.cz,
        dmonakhov@openvz.org, sandeen@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100926022137.GK19690@thunk.org>
References: <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop> <20100926003255.GA19690@thunk.org>
	 <1285462243.6115.89.camel@Joe-Laptop> <20100926010410.GC19690@thunk.org>
	 <1285464746.6115.108.camel@Joe-Laptop> <20100926015328.GI19690@thunk.org>
	 <1285466591.6115.117.camel@Joe-Laptop> <20100926021030.GJ19690@thunk.org>
	 <20100926022137.GK19690@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 19:45:32 -0700
Message-ID: <1285469132.6115.162.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 22:21 -0400, Ted Ts'o wrote:
> P.S.  This is also completely insane:
>     --git-min-percent => minimum percentage of commits required (default: 5)
> Anyone who has 5% of the commits should be considered a maintainer?!?

Probably --git-min-signatures=1 isn't high enough either.

I have no issue changing those to whatever is appropriate.

I believe the only person to comment on the % before
was Mark Brown, who might have suggested that number.

There've always been tradeoffs between activity on the file,
direct maintainership and reasonable accuracy of patterns.

Today, patterns are mostly reasonable, except for arch/arm/.

