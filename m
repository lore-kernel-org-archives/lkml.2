Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1HOSgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:36:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53889 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1HOSgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110729180028.6a2091b3.rdunlap@xenotime.net>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>
Date: Mon, 15 Aug 2011 14:36:41 -0400
Message-ID: <CACqU3MU-T2cftzSqufFGpYJYeiC0Vbipf+LtpBrJD4RVdef2AQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Waychison <mikew@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 29, 2011 at 9:00 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Introduce "Internal-reference-ID:" for company-internal
> patch tracking.  Also clarify that URLs in patches should be
> public, not private.
>
> Based on emails from Greg Kroah-Hartman.
>
> Internal-reference-ID: rdunlap.2011.0729.id1
>
What's the point of this for individuals ? Couldn't the Message-id
from the mail be re-used ?

 - Arnaud

> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Mike Waychison <mikew@google.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Theodore Tso <tytso@MIT.EDU>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  Documentation/SubmittingPatches |   25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> --- linux-3.0-git11.orig/Documentation/SubmittingPatches
> +++ linux-3.0-git11/Documentation/SubmittingPatches
> @@ -108,7 +108,14 @@ This benefits both the patch merger(s) a
>  probably didn't even receive earlier versions of the patch.
>
>  If the patch fixes a logged bug entry, refer to that bug entry by
> -number and URL.
> +number and URL (for URLs that are public, i.e., available to
> +everyone).
> +
> +Please don't include private (internal) URLs in patch descriptions,
> +so just say something like:
> +       Fixes fubar.com bugzilla #4311
> +instead of
> +       Fixes bugzilla.fubar.com/show_bug.cgi?id=4311
>
>
>  3) Separate your changes.
> @@ -469,7 +476,19 @@ understand the subject area and to perfo
>  increase the likelihood of your patch getting into the kernel.
>
>
> -15) The canonical patch format
> +15) Internal-reference-ID: tag
> +
> +Sometimes a company wants to include an internal reference ID (tag)
> +in a patch so that they can have better patch tracking.  Instead of
> +having a bazillion different such ID tags, the accepted one for
> +everyone to use is:
> +
> +Internal-reference-ID: <text>
> +
> +<text> should not be a private (internal) URL.
> +
> +
> +16) The canonical patch format
>
>  The canonical patch subject line is:
>
> @@ -583,7 +602,7 @@ See more details on the proper patch for
>  references.
>
>
> -16) Sending "git pull" requests  (from Linus emails)
> +17) Sending "git pull" requests  (from Linus emails)
>
>  Please write the git repo address and branch name alone on the same line
>  so that I can't even by mistake pull from the wrong branch, and so
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
