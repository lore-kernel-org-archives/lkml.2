Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1JJPUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:20:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55404 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751000Ab1JJPUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:20:44 -0400
Message-ID: <1318260043.25811.11.camel@Joe-Laptop>
Subject: Re: [PATCH 4/6] udf: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 08:20:43 -0700
In-Reply-To: <20111010145953.GC3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	 <cover.1318233879.git.joe@perches.com>
	 <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
	 <20111010145953.GC3944@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 16:59 +0200, Jan Kara wrote:
> On Mon 10-10-11 01:08:05, Joe Perches wrote:
> > Use the current logging styles.
> > Convert a few printks that should have been udf_warn and udf_err.
> > Coalesce formats.  Add #define pr_fmt.
> > Move an #include "udfdecls.h" above other includes in udftime.c
> > so pr_fmt works correctly.  Strip prefixes from conversions as appropriate.
> > Reorder logging definitions in udfdecl.h
>   Any reason why you didn't use udf_err() / udf_warn() in all the places
> where sb pointer is available?

I did it in the places where sb was otherwise used
in the output message.

> Also I'd further use udf_err() in
> udf_parse_options() - passing sb there is simple and additional information
> in the message is useful. Thanks.

Maybe NamJae can do that in a follow-on patch.

NamJae, I broke up your larger patch so you could
see an example of the preferred form of smaller,
targeted patches.


