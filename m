Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1AUGjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:39:24 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:46174 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1AUGjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:39:22 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, general questions
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@gmail.com, npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <E1PfsUI-0007gV-Gw@pomaz-ex.szeredi.hu>
References: <20110113120626.GB30351@opensource.wolfsonmicro.com> <8138.1294924927@jrobl> <676f5c24375e1cc2aa14fe6630ef1324@mail.gmail.com> <8482.1294926315@jrobl> <AANLkTim=VY7+fo6d_nUXVxs+iZ_f79qWu_eYMUjvhVJO@mail.gmail.com> <909.1295419383@jrobl> <AANLkTi=CqLm=33acFV42N8VbNK9=hwXV9iegKn-jjGJS@mail.gmail.com> <13379.1295514315@jrobl> <E1PfsUI-0007gV-Gw@pomaz-ex.szeredi.hu>
Date: Fri, 21 Jan 2011 15:38:59 +0900
Message-ID: <19352.1295591939@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> No it doesn't.  dentry_unhash() doesn't drop the dentry from the hash
> unless it has no other references, cwd being one such ref.

I see.
When chdir() completets before vfs_rename_dir(), the dir will not be
unhashed. It is OK.

Even if the dir is unhashed temporary before chdir(), then the lookup
fallback to ref-walk and i_mutex protects. It is OK too.

Thank you.
J. R. Okajima
