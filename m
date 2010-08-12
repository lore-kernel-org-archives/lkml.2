Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab0HLJO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:14:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:45639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759109Ab0HLJO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:14:56 -0400
Message-ID: <4C63BB09.80609@suse.cz>
Date: Thu, 12 Aug 2010 11:12:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 0/2] kconfig: fixes for savedefconfig
References: <20100812071023.GA11148@merkur.ravnborg.org>
In-Reply-To: <20100812071023.GA11148@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.8.2010 09:10, Sam Ravnborg wrote:
> While tranislating all remaining defconfigs in
> the kernel to the minimal format I encountered
> an issue where the resulting .config was not
> equal to the original.
> 
> This was tracked down to missing info in the saved defconfig file.
> 
> Arve reported another problem with tristate choice that was
> reproduceable with a small config sample.
> 
> The followng patches fixes both issues.
> There is no outstanding issue with respect to savedefconfig.

Applied, thanks a lot Sam!

Michal
