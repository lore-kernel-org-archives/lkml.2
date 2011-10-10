Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1JJRZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:25:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57736 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751258Ab1JJRZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:25:11 -0400
Message-ID: <1318267510.27825.20.camel@Joe-Laptop>
Subject: Re: [PATCH 4/6] udf: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, NamJae Jeon <linkinjeon@gmail.com>
Date: Mon, 10 Oct 2011 10:25:10 -0700
In-Reply-To: <20111010164157.GH3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	 <cover.1318233879.git.joe@perches.com>
	 <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
	 <20111010145953.GC3944@quack.suse.cz>
	 <1318260214.25811.14.camel@Joe-Laptop>
	 <20111010164157.GH3944@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 18:41 +0200, Jan Kara wrote:
> On Mon 10-10-11 08:23:34, Joe Perches wrote:
> > I forgot to mention that udf_err emits at KERN_CRIT.
> > I think that's not good.
> I've changed udf_err() to call pr_err() because
> KERN_CRIT is really too much.

If this means you applied it or applied it with
modifications, I think it'd be good to either
reply to the 0/n message with something like
"applied to my tree", or reply to each message
as appropriate.

That reply lets other people like NamJae proceed
appropriately.  Otherwise, it's left to some
pull request or patch series posted by you
potentially months later to figure out what's
current.

Is there a udf git tree?

The stuff on sourceforge is not current
and the MAINTAINERS W: entry doesn't work.

Maybe:

diff --git a/MAINTAINERS b/MAINTAINERS
index 644894a..58eb5f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6624,7 +6624,7 @@ F:	drivers/net/ethernet/8390/ne-h8300.c
 
 UDF FILESYSTEM
 M:	Jan Kara <jack@suse.cz>
-W:	http://linux-udf.sourceforge.net
+W:	http://sourceforge.net/projects/linux-udf/develop
 S:	Maintained
 F:	Documentation/filesystems/udf.txt
 F:	fs/udf/

cheers, Joe


