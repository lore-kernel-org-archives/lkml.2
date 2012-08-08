Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2HHPBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:01:43 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34014 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2HHPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:01:42 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2012 11:01:42 EDT
Date: Wed, 8 Aug 2012 09:14:01 -0500 (CDT)
From: "Christoph Lameter (Open Source)" <cl@linux.com>
X-X-Sender: cl@greybox.home
To: Shuah Khan <shuah.khan@hp.com>
cc: JoonSoo Kim <js1304@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, shuahkhan@gmail.com
Subject: Re: [PATCH RESEND] mm: Restructure kmem_cache_create() to move debug
 cache integrity checks into a new function
In-Reply-To: <1344272614.2486.40.camel@lorien2>
Message-ID: <alpine.DEB.2.02.1208080913290.7048@greybox.home>
References: <1342221125.17464.8.camel@lorien2> <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com> <1344224494.3053.5.camel@lorien2> <1344266096.2486.17.camel@lorien2> <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
 <1344272614.2486.40.camel@lorien2>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Shuah Khan wrote:

> No reason, just something I am used to doing :) inline is a good idea. I
> can fix that easily and send v2 patch.

Leave that to the compiler. There is no performance reason that would
give a benefit from forcing inline.

