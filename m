Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2ELJCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 05:02:41 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:54449 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2ELJCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 05:02:39 -0400
Message-ID: <4FAE272C.6080804@msgid.tls.msk.ru>
Date: Sat, 12 May 2012 13:02:36 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: liwp.linux@gmail.com
CC: Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] unmapped quotes
References: <y> <4fae23ca.68db440a.4bc9.22cc@mx.google.com>
In-Reply-To: <4fae23ca.68db440a.4bc9.22cc@mx.google.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.05.2012 12:47, liwp.linux@gmail.com wrote:
> - * If we're over `background_thresh' then the writeback threads are woken to
> + * If we're over 'background_thresh' then the writeback threads are woken to

I can't say the original is wrong.  Since these quotes don't have
"open" and "close" versions like {} or () pairs does, people often
use ` as opening and ' as closing - while staying within ascii.
Alternatives are things like « » or other things, but these aren't
ascii anymore.  So I'd say keep it alone... ;)

/mjt
