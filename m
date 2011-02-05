Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1BEUNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:13:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46276 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1BEUNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:13:04 -0500
Message-ID: <4D4DAF75.5090607@vflare.org>
Date: Sat, 05 Feb 2011 15:13:41 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: zcache and kztmem combine to become the new zcache
References: <4D4D95C6.20505@vflare.org>
In-Reply-To: <4D4D95C6.20505@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, forgot to CC Dan)

On 02/05/2011 01:24 PM, Nitin Gupta wrote:
> To zcache and kztmem users/reviewers --
>
> We, Nitin and Dan, have decided to combine zcache and kztmem and
> call the resulting work as zcache.
>
> Since kztmem has evolved further than zcache, we have agreed to
> use the kztmem code as the foundation for future work, so Dan will
> resubmit the kztmem patchset soon with the name changed to zcache.
>
> Since both the "old zcache" and "new zcache" depend on the proposed
> cleancache patch, Nitin and Dan will jointly work with the Linux
> maintainers to support merging of cleancache, and also work together
> on possibilities for merging frontswap and zram, since they serve
> a similar function.
>
> If you have any questions or concerns, please ensure you reply
> to both of us.
>
> Nitin Gupta and Dan Magenheimer
>

