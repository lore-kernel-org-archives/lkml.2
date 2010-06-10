Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab0FJP1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:27:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:60261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0FJP1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:27:21 -0400
Message-ID: <4C11043D.3040500@kernel.org>
Date: Thu, 10 Jun 2010 17:26:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: hmajxxlh@corbac.com, fuse-devel@lists.sourceforge.net, mszeredi@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] OSS Proxy Jack slave
References: <20100601092456.GA23572@alia.nute.net> <4C066CF4.2050902@gmail.com> <20100605085045.GA5630@alia.nute.net> <4C0A1369.9010601@kernel.org> <E1OMICc-0005f8-G5@pomaz-ex.szeredi.hu> <4C10CB39.70002@kernel.org> <E1OMgIz-0005Wb-2a@pomaz-ex.szeredi.hu> <869cdc8d-85cf-468e-8f94-ff50551684ba@email.android.com> <E1OMhnk-0005i4-8F@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OMhnk-0005i4-8F@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 15:26:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/10/2010 03:28 PM, Miklos Szeredi wrote:
> On Thu, 10 Jun 2010, Tejun Heo wrote:
> I'm sure its a good idea to provide an interface that does't _require_
> server side mmaps.  This doesn't preclude an mmap interface later on,
> but I'd rather start with a "pure" read/write device interface, which
> is in a lot of ways simpler to solve than mmap.

It doesn't preclude that but then again having two interfaces can be a
bit silly.

> As for pinning kernel pages, I still think it's a good idea for the
> char device interface, but you're right, it's not necessary.
> 
> In fact I'm mostly ready with an implementation of store/retrieve that
> just pokes the regular page cache.

But I think if we can avoid using pinned kernel pages, pure r/w based
implementation could be different and useful enough, so yeah, great.

Thanks.

-- 
tejun
