Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab0I0MQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:16:29 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:33900 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab0I0MQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:16:28 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Valerie Aurora <vaurora@redhat.com>,
        linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk
In-Reply-To: <201009271349.49077.agruen@suse.de>
References: <20100920180404.939991832@szeredi.hu> <20100924175653.GB25129@shell> <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu> <201009271349.49077.agruen@suse.de>
Date: Mon, 27 Sep 2010 21:15:29 +0900
Message-ID: <307.1285589729@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andreas Gruenbacher:
> I can think of arguments for either behavior, perhaps with a slight preference 
> for your suggestion (default = opaque).
>
> In any case, admins will need a way to flip opaque flags and remove undesired 
> whiteouts.

Agreed.
Aufs is providing two options for this issue, "diropq=always" and
"diropq=whiteouted". Several years ago, the default was "always". But
soon it changed to "whiteouted" and I have never received objection
from users.
As for as I know, some users are happy since the number of whiteouts was
reduced. Because they merge layers manually for system
maintenance. Unnecessary whiteouts are not good to them.


J. R. Okajima
