Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0HRBYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:24:42 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:37589 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab0HRBYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:24:36 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
To: Valerie Aurora <vaurora@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100817204430.GE5556@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell>
Date: Wed, 18 Aug 2010 10:23:52 +0900
Message-ID: <6820.1282094632@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> and at least three national lab computer clusters.  The best argument
> for their need for a union file system is that they are using unionfs
> and aufs despite the pain of using out-of-mainline code and (according
> to the users I have spoken to) frequent crashes.  Union mounts is

Hmm, anyone who meets crash in aufs, please let me know.
While I never say aufs is bug-free, I don't receive such report
recently. I always try fixing a bug as soon as possible when I got a
report.

A reply I have to write repeatedly to who have met a problem in aufs and
reported to aufs-users ML, is "your aufs version is too old. please get
the latest one."
Because aufs is released every week and some linux distributions keep
using very old aufs version, even over one year old version than thier
release date.

By the way, I don't have objection to merge Val's UnionMount into
mainline as I have heard it is already decided.


> But frankly, this is an impossible problem to solve generically at the
> file system level.  When a user says, "Show the changes to the lower
> file system in my overlaid file system," they are actually saying,

Is it (mostly) possible by receiving a notification via fsnotify?
For remote FS, their ->d_revalidate() will tell us something is changed.


J. R. Okajima
