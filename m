Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0DSWUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:20:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50104 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab0DSWUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:20:00 -0400
Message-ID: <4BCCD52B.4090906@zytor.com>
Date: Mon, 19 Apr 2010 15:11:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: maximilian attems <max@stro.at>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] fcntl.h: define AT_EACCESS
References: <1271387280-19565-1-git-send-email-max@stro.at> <20100419144729.2b8180e8.akpm@linux-foundation.org> <20100419215711.GR10984@baikonur.stro.at> <4BCCD4BD.3030303@redhat.com>
In-Reply-To: <4BCCD4BD.3030303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 03:10 PM, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 04/19/2010 02:57 PM, maximilian attems wrote:
>> the dash code calling faccessat has the 4 params,
>> klibc faccessat had only 3 args, guess nobody had used it before.
> 
> The function is implemented at userlevel.  The kernel code has the same
> name but isn't a complete implementation.  There is no point in defining
> the symbol in the kernel headers.
> 

They should be added as a comment, at least, to avoid future conflicts.

	-hpa
