Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2KZTnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:43:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:34354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2KZTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:43:16 -0500
Message-ID: <50B3C64C.1010801@infradead.org>
Date: Mon, 26 Nov 2012 11:43:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Dubov <oakad@yahoo.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 26 (mmc/host/tifm_sd.c)
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
In-Reply-To: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 06:17 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20121115:
> 


on i386:

drivers/built-in.o: In function `tifm_sd_request':
tifm_sd.c:(.text+0x588f95): undefined reference to `__udivdi3'


somewhere inside tifm_sd_request():

I'm guessing that the call to tifm_sd_set_data_timeout() was
inlined by gcc and it's the divide there that is the problem.

-- 

~Randy
