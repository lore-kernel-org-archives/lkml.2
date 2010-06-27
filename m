Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0F0UH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 16:07:29 -0400
Received: from xenotime.net ([72.52.115.56]:34187 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755845Ab0F0UH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 16:07:27 -0400
Date: Sun, 27 Jun 2010 13:07:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kulikov Vasiliy <segooon@gmail.com>, Jiri Kosina <trivial@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Nick Bowler <nbowler@elliptictech.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] Documentation/sysctl/vm.txt typo
Message-Id: <20100627130720.d9c16b83.rdunlap@xenotime.net>
In-Reply-To: <20100627035106.GA25692@shinshilla>
References: <1276859270.3159.5.camel@shinshilla>
	<20100618142252.GA31086@elliptictech.com>
	<20100618154033.1e949749.rdunlap@xenotime.net>
	<20100625110801.GB6896@shinshilla>
	<AANLkTinu8OkcfANcJAFELtiPXTC9pfJTDsdSXugJ2xN3@mail.gmail.com>
	<20100627035106.GA25692@shinshilla>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010 07:51:06 +0400 Kulikov Vasiliy wrote:

> Fix trivial typo: duplicated word.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Thanks.
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Kulikov, in the future, please send such small patches to:

TRIVIAL PATCHES
M:	Jiri Kosina <trivial@kernel.org>
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
S:	Maintained


Jiri, will you pick this up, please?


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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
