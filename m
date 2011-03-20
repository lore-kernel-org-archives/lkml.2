Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1CTRfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 13:35:09 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:58462 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751621Ab1CTRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 13:35:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XUd6Qe9DEM3ESJS+O0iF8uUKekOL76hTa8LgnqzXu+KRtm+x3eeDj3zpO6c4rM+Ru7yMQm3v9T8w+H4s67gut3CNcvrV5qiosDQxRIIjuk62Gb0nkG/UQ8QIwcZdJ4nQ;
Date: Sun, 20 Mar 2011 10:35:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arne Jansen <lists@die-jansens.de>
Cc: Jeffrin Jose <ahiliation@yahoo.co.in>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: aligning with spaces [was: Re: format fixes]
Message-Id: <20110320103503.8de522d1.rdunlap@xenotime.net>
In-Reply-To: <4D860381.30706@die-jansens.de>
References: <20110320104527.GA3120@debian.Jeff>
	<4D860381.30706@die-jansens.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Mar 2011 14:39:13 +0100 Arne Jansen wrote:

> On 20.03.2011 11:45, Jeffrin Jose wrote:
> > I have created a patch with fixes and format
> > error by replacing spaces with tabs.
> 
> The CodingStyle guide seems to me a big vague on this topic, but
> checkpatch.pl has a clear idea of what is right and wrong. But
> the formerly present indentation seems to me totally valid.

AFAICT, the patch replaces 8 spaces with 1 tab.  That's a good change
IMO, except that the patch does not apply to linux-next 2011-0318.
I can't tell if the patch was made against an earlier tree or a later one.
In either case, it looks like this particular printk has probably already
been fixed by some other patch.

> Use tab to indent to the current indentation level, then continue
> with spaces for the alignment of broken-up lines. This has a
> few advantages. One of them is that the code still looks neat with
> a different tab size (of course, no one ever does that). Another is,
> that editing is easier if you change the name of the function and
> with it the needed alignment for the following lines.
> If we really require using tabs as much as possible for aligning, we
> should also _only_ use tabs for it and require e.g. 2 tabs for
> broken-up lines.
> In fact, the example in CodingStyle uses only tabs and does not try
> to align the double quotes of the broken-up string with each other.

We accept patches either way, but it mostly depends on (a) the
current/surrounding code and (b) the maintainer who is merging the patches.

CodingStyle may be vague on all of this.  It's easy to be ambiguous or
vague in language, even when you try not to be.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
