Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab0FROYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:24:53 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:34907 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933459Ab0FROYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:24:52 -0400
Date: Fri, 18 Jun 2010 10:22:52 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation/sysctl/vm.txt typo
Message-ID: <20100618142252.GA31086@elliptictech.com>
Mail-Followup-To: Kulikov Vasiliy <segooon@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
References: <1276859270.3159.5.camel@shinshilla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276859270.3159.5.camel@shinshilla>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:07 Fri 18 Jun     , Kulikov Vasiliy wrote:
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -196,7 +196,7 @@ controlled by this knob are discussed in
> Documentation/laptops/laptop-mode.txt.
>  
>  legacy_va_layout
>  
> -If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the
> kernel
> +If non-zero, this sysctl disables the new 32-bit mmap layout - the
> kernel
>  will use the legacy (2.4) layout for all processes.

You might want to check your mailer settings: this patch has been
mangled.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
