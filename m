Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0L2NHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 08:07:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:49568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0L2NHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 08:07:16 -0500
Date: Wed, 29 Dec 2010 14:07:13 +0100
From: Michal Marek <mmarek@suse.cz>
To: maximilian attems <max@stro.at>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: create linux-headers package in deb-pkg
Message-ID: <20101229130713.GA15139@sepie.suse.cz>
References: <1293201730-1583-1-git-send-email-tytso@mit.edu>
 <20101225112026.GF20262@vostochny.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101225112026.GF20262@vostochny.stro.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 11:20:26AM +0000, maximilian attems wrote:
> On Fri, Dec 24, 2010 at 09:42:10AM -0500, Theodore Ts'o wrote:
> > Create a linux-headers-$KVER.deb package which can be used to build
> > external modules without having the source tree around.

Thanks, applied to kbuild-2.6.git#packaging.

> fjp had back a year ago asked for a bindeb-pkg once we add more things
> to deb-pkg. I had submitted linux-libc-dev built out of deb-pkg
> http://marc.info/?l=linux-kbuild&m=125737390700914&w=2
> 
> It's an orthogonal issue, but just to clear it up.

Can you repost it? It seems I missed it when I was taking over kbuild
from Sam last year.

Michal
