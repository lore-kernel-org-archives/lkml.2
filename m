Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1BOGC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:02:56 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49613 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1BOGCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tq7+zYX30N15fMHRz+wfc7JZTychcUG2TtDIC42KPynVge5iwh4W5m3BlaG8F4wyC0
         yUOP8EKEkEjcT1ZEQt1qhFShXj/CutxGpgGSqWjeU6xCzedePCv7taG5rzO3HyG60n5M
         om3Wr54lOGEKCyAISwjvwQL3Gr+c+cZOOagyw=
Date: Tue, 15 Feb 2011 14:02:29 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, harryxiyou@gmail.com
Subject: Re: + maintainers-add-topgit-for-t.patch added to -mm tree
Message-ID: <20110215060225.GA2085@gmail.com>
Mail-Followup-To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, harryxiyou@gmail.com
References: <201102142154.p1ELsvwt027845@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102142154.p1ELsvwt027845@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 01:54:56PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      MAINTAINERS: add topgit for T:
> has been added to the -mm tree.  Its filename is
>      maintainers-add-topgit-for-t.patch
Thanks.
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
Thanks, i will remember the rules :)
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
Thanks, i will do.

Best Regards.
Harry Wei.
> ------------------------------------------------------
> Subject: MAINTAINERS: add topgit for T:
> From: Harry Wei <jiaweiwei.xiyou@gmail.com>
> 
> At least one tree:
> 
> 	ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
> 
> is available via topgit.  Add mention of topgit in the MAINTAINERS
> description section.
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN MAINTAINERS~maintainers-add-topgit-for-t MAINTAINERS
> --- a/MAINTAINERS~maintainers-add-topgit-for-t
> +++ a/MAINTAINERS
> @@ -72,7 +72,7 @@ Descriptions of section entries:
>  	L: Mailing list that is relevant to this area
>  	W: Web-page with status/info
>  	Q: Patchwork web based patch tracking system site
> -	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
> +	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.
>  	S: Status, one of the following:
>  	   Supported:	Someone is actually paid to look after this.
>  	   Maintained:	Someone actually looks after it.
> _
> 
> Patches currently in -mm which might be from jiaweiwei.xiyou@gmail.com are
> 
> linux-next.patch
> maintainers-add-topgit-for-t.patch
> 
