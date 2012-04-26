Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab2DZQns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:43:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47730 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab2DZQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:43:46 -0400
Message-ID: <4F997B39.8020405@landley.net>
Date: Thu, 26 Apr 2012 11:43:37 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Subodh Nijsure <snijsure@grid-net.com>
CC: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH] Recommend correct way to submit new version of the patches.
References: <1335390717-32165-1-git-send-email-snijsure@grid-net.com>
In-Reply-To: <1335390717-32165-1-git-send-email-snijsure@grid-net.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 04:51 PM, Subodh Nijsure wrote:
> Russell King suggested proper way to submit new versions of the patches.
> See http://lists.infradead.org/pipermail/linux-arm-kernel/2012-April/096236.html
> Modify SubmittingPatches to summerize that recommendation.
> 
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
> ---
>  Documentation/SubmittingPatches |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 4468ce2..4b166a4 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -579,6 +579,18 @@ use diffstat options "-p 1 -w 70" so that filenames are listed from
>  the top of the kernel source tree and don't use too much horizontal
>  space (easily fit in 80 columns, maybe with some indentation).
>  
> +Please don't thread the posting of a new version of the patches to
> +the previous posting of the older version.

I prefer documentation emphasize "Do X" rather than "Don't do X".

> In other words, the
> +initial summary mail for Vn should not be threaded to the Vn-1
> +series,

They should instead be in reply to some _other_ random message?

> and the individual patches for Vn should only be threaded
> +to the initial summary mail for Vn.

They can be threaded to more than one thing at a time?

> +This is to avoid one massive
> +thread for a proposed patch.
> +
> +If you wish to provide a direct reference back to a previous thread,
> +please do so via URLs into archives, or providing the message id or
> +exact subject of the previous series in the new summary message body.

If you're going to give the subject, give the date it was posted.

> +But please don't thread each version to the previous version!

Repeating your topic sentence with an exclamation point at the end
doesn't really help matters here.

Would you like me to take a stab at wordsmithing this? Something like:

  Each patch series should ideally start with a 0/X summary message
  explaining the purpose of the series, with each Y/X message posted as
  a reply to that summary.

  Post each new version of a patch series as its own thread. This avoids
  unmanageably long threads and burying new activity in old threads
  where it's less likely to be noticed. To reference a previous series,
  give a URL to a web archive, or provide the message ID, or the
  subject line and date of the previous posting.

(The existing context doesn't even mention 0/5 summary messages, and the
hunk about "When you submit or resubmit" is up at line 101 rather than
down in the 580's...)

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
