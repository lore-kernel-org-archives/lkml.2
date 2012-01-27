Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2A0SMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:12:16 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37202 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166Ab2A0SML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:12:11 -0500
X-Sasl-enc: 1OpezdWL+o0Qduce3FMD7CqiJqmtxOwNDGVSgzi21j/G 1327687930
Date: Fri, 27 Jan 2012 10:01:18 -0800
From: Greg KH <greg@kroah.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: android: Remove pmem driver
Message-ID: <20120127180118.GA28530@kroah.com>
References: <1327608102.3060.17.camel@lorien.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327608102.3060.17.camel@lorien.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 01:01:42PM -0700, Shuah Khan wrote:
> Addroid pmem driver is no longer used in any of the Android products.
> This patch removes pmem driver from Android staging area
> 
> Reference: https://lkml.org/lkml/2012/1/23/183
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> 
> ---
>  drivers/staging/android/Kconfig        |    4 -
>  drivers/staging/android/Makefile       |    1 -
>  drivers/staging/android/android_pmem.h |   93 ---
>  drivers/staging/android/pmem.c         | 1345
> --------------------------------

The patch is line-wrapped and can not be applied, please resend it in a
format that I can apply it in.

Also, please always cc: the subsystem maintainer for the patch,
otherwise it is often missed by just sending to lkml without any cc: on
it.

thanks,

greg k-h
