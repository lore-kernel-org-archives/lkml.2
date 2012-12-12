Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab2LLIC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:02:56 -0500
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:37674 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2LLICy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:02:54 -0500
Date: Wed, 12 Dec 2012 09:58:16 +0100
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] AES instead of SHA1 for /dev/urandom
Message-ID: <20121212085815.GA3151@domone.kolej.mff.cuni.cz>
References: <20121212020354.GA30879@domone.kolej.mff.cuni.cz>
 <20121212130826.7940b428@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121212130826.7940b428@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:08:26PM +1100, NeilBrown wrote:
> On Wed, 12 Dec 2012 03:03:54 +0100 Ondřej Bílka <neleai@seznam.cz> wrote:
> 
> > I consider to speed-up /dev/urandom on recent intel processors by
> > using hardware aes. Same for accelerated aes crypto.
> > 
> > Would you accept a patch if I wrote it?
> 
> Have you read  https://lwn.net/Articles/525459  ?
> 
Yes
> In particular the paragraph containing:
> 
>    A member of the audience asked why the kernel couldn't just do away with
>    the existing system and use the HWRNG directly.
> 
> Does that answer your question in any way?
> 
No as AES is a HWRNG about as much as horse is type of automobile.

Ondra
