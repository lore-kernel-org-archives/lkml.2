Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0IZA6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:58:45 -0400
Received: from mail.perches.com ([173.55.12.10]:2389 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0IZA6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:58:44 -0400
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
        adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285462243.6115.89.camel@Joe-Laptop>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <20100925233600.GA2854@lst.de>
	 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop>  <20100926003255.GA19690@thunk.org>
	 <1285462243.6115.89.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 17:58:42 -0700
Message-ID: <1285462722.6115.95.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 17:50 -0700, Joe Perches wrote:
> Now git history is used only if there is no specifically
> named maintainer.

Many initial contributors of drivers and such put
their name in MAINTAINERS and stop soon after.

There are many "MAINTAINERS" that are inactive and
no longer contributors.

I suppose another change might be to cc signers when
the listed MAINTAINER has no sign-offs.



