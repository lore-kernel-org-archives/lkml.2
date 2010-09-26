Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0IZAGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:06:23 -0400
Received: from mail.perches.com ([173.55.12.10]:2363 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab0IZAGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:06:22 -0400
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@lst.de>
Cc: T Dent <tdent48227@gmail.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
        jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100925235643.GA3224@lst.de>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <20100925233600.GA2854@lst.de>
	 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 17:06:19 -0700
Message-ID: <1285459579.6115.72.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-26 at 01:56 +0200, Christoph Hellwig wrote:
> On Sat, Sep 25, 2010 at 07:53:02PM -0400, T Dent wrote:
> > On 9/25/10, Christoph Hellwig <hch@lst.de> wrote:
> > > Please don't Cc me on ext4 patches, thanks.
> > Ok.. i just used the get maintainer script and your name was on it.
> The script is broken but the maintainer refuses to fix it.

That'd be false.

https://patchwork.kernel.org/patch/185352/

That version is in Andrew Morton's mm.

$ ./scripts/get_maintainer.pl -f  fs/ext4/acl.c
"Theodore Ts'o" <tytso@mit.edu>
Andreas Dilger <adilger.kernel@dilger.ca>
linux-ext4@vger.kernel.org

cheers, Joe

