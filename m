Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab1JDSRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:17:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab1JDSRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:17:36 -0400
Date: Tue, 4 Oct 2011 11:02:37 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
Message-ID: <20111004180237.GA15087@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317750395.18063.11.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 01:46:34PM -0400, Steven Rostedt wrote:
> +my $pgp = `gpg --simple-sk-checksum -a --detach-sign $pass --output - < $tmpfile`;

Try not to use gpg when calling from scripts, use gpgv instead, it
handles things much better, and sets the return value correctly so you
can check it (which I don't think you do here.)

Now if only someone can get quilt working properly for git's "split"
 subject: lines, I would be very happy...

thanks,

greg k-h
