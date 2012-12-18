Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2LRTen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:34:43 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56529 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096Ab2LRTel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:34:41 -0500
Message-ID: <1355859281.30366.29.camel@joe-AO722>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 18 Dec 2012 11:34:41 -0800
In-Reply-To: <20121218182838.GF31255@liondog.tnic>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
	 <50CEF080.8010208@suse.cz> <20121217102714.GB31947@liondog.tnic>
	 <1355758544.13361.14.camel@joe-AO722> <20121217170011.GC31866@liondog.tnic>
	 <1355770579.13361.41.camel@joe-AO722> <1355771383.13361.44.camel@joe-AO722>
	 <20121218182838.GF31255@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 19:28 +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 11:09:43AM -0800, Joe Perches wrote:
> > This needs a new test here to avoid chirping
> > on files that aren't added, deleted or renamed.
> > 
> > 		next if ($realfile eq $modifiedfile);
> 
> Hmm, I don't think that catches file renames when using the normal 'git
> diff' output:

That depends on whether or not an actual patch follows.

This looks for the +++ and --- lines
in a patch.

If no patch is attached, you should get

ERROR: Does not appear to be a unified-diff format patch


