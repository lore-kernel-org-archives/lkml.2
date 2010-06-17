Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab0FQSFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:05:24 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:63097 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550Ab0FQSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:05:22 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH v2] d_ino considered harmful
To: David Dillow <dillowda@ornl.gov>
Cc: Valerie Aurora <vaurora@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1276721084.13788.53.camel@lap75545.ornl.gov>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell> <1276721084.13788.53.camel@lap75545.ornl.gov>
Date: Fri, 18 Jun 2010 03:04:08 +0900
Message-ID: <30568.1276797848@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Dillow:
> For example, our main Lustre scratch space has over 285 million files in
> it, and using find -inum takes over 72 hours to walk the tree using
	:::
> Using ne2scan -- which uses libext2fs and combines the inode scan and
> the name lookup -- takes over 48 hours to generate a list of candidate
> files for the purge example. With an optimized inode scan and the custom
	:::

While I've never heard of ne2scan, I am interested in this simplified
problem such as "find the pathname(s) from an inum in a huge fs."
Is ne2scan essentially equivalent to "debugfs ncheck inum"?

About Valeris's patch, as long as "ls -i" is useful/helpful,
> +	/* Use of d_ino without st_dev is always buggy. */
is not true.


J. R. Okajima

