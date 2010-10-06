Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0JFAY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:24:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59676 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab0JFAY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nkr30E5IAYUyIsfE22VcTiv+APSFx/roORoco0fX2lmrfvJiAgYy389EEBI+zYAJfZ
         APLuTOwiKGubbiDCXjdP7pH/iSgIBpv9kcEF6TccPWkHieDyHThpHnLC8RrhqrhGwVBv
         m7cMPYwJpJbT3boTghna0m9DamPPLNtDLBgiw=
MIME-Version: 1.0
In-Reply-To: <AANLkTik34ZKasZMMpx4wD71k+RPccGLvAi1Cwe5UwZpj@mail.gmail.com>
References: <AANLkTik34ZKasZMMpx4wD71k+RPccGLvAi1Cwe5UwZpj@mail.gmail.com>
Date: Wed, 6 Oct 2010 09:24:56 +0900
Message-ID: <AANLkTimbamyq6TnOVmMOjnG2hNWYwsvqBZ2RRvSTXr+X@mail.gmail.com>
Subject: Re: [PATCH] pramfs: Persistent and protected RAM filesystem
From: Minchan Kim <minchan.kim@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Tue, Oct 5, 2010 at 8:39 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Hi all,
>
> after a lot of improvement, test, bug fix and new features, it's the
> moment for third round with the kernel community to submit PRAMFS for
> mainline. First of all, I have to say thanks to Tim Bird and CELF to
> actively support the project.

Good to know.
Thanks for your endless effort. :)

>
> Since the last review (June 2009) a lot of things are changed:
>
> - removed any reference of BKL
> - fixed the endianess for the fs layout
> - added support for extended attributes, ACLs and security labels
> - moved out any pte manipulations from fs and inserted them in mm
> - implemented the new truncate convention
> - fixed problems with 64bit archs
>
> ...and much more. Complete "story" in the ChangeLog inserted in the
> documentation file.
>
> Since the patch is long, you can download and review the patch from
> the project site: http:\\pramfs.sourceforge.net. The patch version is
> 1.2.1 for kernel 2.6.36.
> In addition, in the web site tech page, you can find a lot of
> information about implementation, technical details, benchemarking and
> so on.

If you really want to merge it, you have to divide patch into
individual patches instead of all-at-once patch.
Individual patches should have a description and clear feature to
review more easily.
And still we need all-at-once patch to apply the patch and test easily.

> Regards,
>
> Marco
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>



-- 
Kind regards,
Minchan Kim
