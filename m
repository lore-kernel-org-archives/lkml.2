Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab2HHPN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:13:57 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4930 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab2HHPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:13:55 -0400
Message-ID: <1344438832.2832.1.camel@lorien2>
Subject: Re: [PATCH RESEND] mm: Restructure kmem_cache_create() to move
 debug cache integrity checks into a new function
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: "Christoph Lameter (Open Source)" <cl@linux.com>
Cc: JoonSoo Kim <js1304@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, shuah.khan@hp.com
Date: Wed, 08 Aug 2012 09:13:52 -0600
In-Reply-To: <alpine.DEB.2.02.1208080913290.7048@greybox.home>
References: <1342221125.17464.8.camel@lorien2>
	 <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com>
	 <1344224494.3053.5.camel@lorien2> <1344266096.2486.17.camel@lorien2>
	 <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
	 <1344272614.2486.40.camel@lorien2>
	 <alpine.DEB.2.02.1208080913290.7048@greybox.home>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 09:14 -0500, Christoph Lameter (Open Source)
wrote:
> On Mon, 6 Aug 2012, Shuah Khan wrote:
> 
> > No reason, just something I am used to doing :) inline is a good idea. I
> > can fix that easily and send v2 patch.
> 
> Leave that to the compiler. There is no performance reason that would
> give a benefit from forcing inline.
> 

Already fixed in the v2 patch.

Thanks,
-- Shuah

