Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2KTPWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:22:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2KTPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:22:32 -0500
Date: Tue, 20 Nov 2012 15:22:27 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Constantine Shulyupin <const@makelinux.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
Message-ID: <20121120152227.GI7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
 <20121120142906.GD7955@dm>
 <1353422629.11235.10.camel@joe-AO722>
 <20121120144742.GG7955@dm>
 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
 <1353423503.11235.12.camel@joe-AO722>
 <CAE7jHC-QqYCvSVR2JwCQjrSx6yH0-41GXfid6FSPP3xB8FV=2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7jHC-QqYCvSVR2JwCQjrSx6yH0-41GXfid6FSPP3xB8FV=2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 05:10:43PM +0200, Constantine Shulyupin wrote:
> On Tue, Nov 20, 2012 at 4:58 PM, Joe Perches <joe@perches.com> wrote:
> > I don't think it's an issue.  I'm not sure anyone
> > really uses --ignore for much other than LONG_LINE.
> 
> Indeed. Must all code be 80 characters width?  My be my be better to
> make line length configurable than ignore it? Or at least print actual
> line length to allow developer be aware how long lines is.
> I think 90 char line is preferable than wrapped two or even three times line.

If wrapping there is that much better then wrapping there is appropriate
in some cases.  The currently limit has been revisited a bunch of times,
and in none have we agreed on what to change it to.  It therefore
remains the recommendation.

-apw
