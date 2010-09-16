Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0IPRuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:50:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32868 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572Ab0IPRuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:50:03 -0400
Message-ID: <4C9258C1.3060906@zytor.com>
Date: Thu, 16 Sep 2010 10:49:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] BKL: Remove BKL from autofs4
References: <1284659185-8942-1-git-send-email-arnd@arndb.de> <1284659185-8942-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1284659185-8942-5-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 10:46 AM, Arnd Bergmann wrote:
> autofs4 uses the BKL only to guard its ioctl operations.
> This can be trivially converted to use a mutex, as we have
> done with most device drivers before.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  fs/autofs4/root.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)

You may want to Cc: the maintainer, Ian Kent.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

