Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab1FJUSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:18:45 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47034 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757900Ab1FJUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:18:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sNVaYIBOq8413dsunOWB/YQXtUaunVVunY9X4i5aiHTSJWBZ570mWW76hk3juhy91kz03Mu2uhaDcdAviQwWZ3OfG1TogEhuIdtD5APMuyrBW6JK2x9545o7MKWiXtUF;
Date: Fri, 10 Jun 2011 13:18:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Maxin B John <maxin.john@gmail.com>
Cc: catalin.marinas@arm.com, dbaluta@ixiacom.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update kmemleak architecture support
 info
Message-Id: <20110610131838.43cc5247.rdunlap@xenotime.net>
In-Reply-To: <20110610190956.GA2742@maxin>
References: <20110610190956.GA2742@maxin>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 22:09:56 +0300 Maxin B John wrote:

> >> I think Daniel's suggestion is better, we don't have to worry about
> >> changing the documentation every time we add a new architecture.
> I agree with that.
> 
> > Please send an updated patch without the currently-supported list
> > of architectures.
> Please find the updated patch below: 
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Applied, thanks.

> ---
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> index 090e6ee..51063e6 100644
> --- a/Documentation/kmemleak.txt
> +++ b/Documentation/kmemleak.txt
> @@ -11,7 +11,9 @@ with the difference that the orphan objects are not freed but only
>  reported via /sys/kernel/debug/kmemleak. A similar method is used by the
>  Valgrind tool (memcheck --leak-check) to detect the memory leaks in
>  user-space applications.
> -Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
> +
> +Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug for supported
> +architectures.
>  
>  Usage
>  -----
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
