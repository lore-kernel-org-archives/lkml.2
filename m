Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0F0Bdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 21:33:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41942 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab0F0Bdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 21:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v3o2FD+aCJWj72y7QVY9YcQ67FZ+KShJQ/9tYdyQtZmkw9bDeVc0fwT97Oio1QRdP8
         Ldp/30iSLIgPIbQc3sgd5SDZpI/SfMQjIPfUZmxfSv0fKXPdEOg9qFp4tkIcWWuvC8iI
         NTo7IbGcyzwRzJ4jL+qKQ4VsvWN3RjpjRD1eE=
MIME-Version: 1.0
In-Reply-To: <20100625110801.GB6896@shinshilla>
References: <1276859270.3159.5.camel@shinshilla>
	<20100618142252.GA31086@elliptictech.com>
	<20100618154033.1e949749.rdunlap@xenotime.net>
	<20100625110801.GB6896@shinshilla>
Date: Sun, 27 Jun 2010 10:33:29 +0900
Message-ID: <AANLkTinu8OkcfANcJAFELtiPXTC9pfJTDsdSXugJ2xN3@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation/sysctl/vm.txt typo
From: Minchan Kim <minchan.kim@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Nick Bowler <nbowler@elliptictech.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, Jun 25, 2010 at 8:08 PM, Kulikov Vasiliy <segooon@gmail.com> wrote:
> Fix trivial typo: duplicated word.
>
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 5fdbb61..82b2da1 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -196,7 +196,7 @@ controlled by this knob are discussed in Documentation/laptops/laptop-mode.txt.
>
>  legacy_va_layout
>
> -If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the kernel
> +If non-zero, this sysctl disables the new 32-bit mmap layout - the kernel
>  will use the legacy (2.4) layout for all processes.
>
>  ==============================================================
>

Please, add your sign.
You can refer 12) in Documentation/SubmittingPatch.

Thanks for your contribution.



-- 
Kind regards,
Minchan Kim
