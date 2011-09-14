Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab1INTfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:35:10 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52698 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890Ab1INTfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:35:09 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 15:35:08 EDT
Date: Wed, 14 Sep 2011 12:27:44 -0700
From: Kees Cook <kees@ubuntu.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
Message-ID: <20110914192744.GC4529@outflux.net>
References: <20110910164001.GA2342@albatros>
 <20110910164134.GA2442@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110910164134.GA2442@albatros>
Organization: Ubuntu
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

On Sat, Sep 10, 2011 at 08:41:34PM +0400, Vasiliy Kulikov wrote:
> Historically /proc/slabinfo has 0444 permissions and is accessible to
> the world.  slabinfo contains rather private information related both to
> the kernel and userspace tasks.  Depending on the situation, it might
> reveal either private information per se or information useful to make
> another targeted attack.  Some examples of what can be learned by
> reading/watching for /proc/slabinfo entries:
> ...
> World readable slabinfo simplifies kernel developers' job of debugging
> kernel bugs (e.g. memleaks), but I believe it does more harm than
> benefits.  For most users 0444 slabinfo is an unreasonable attack vector.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Haven't had any mass complaints about the 0400 in Ubuntu (sorry Dave!), so
I'm obviously for it.

Reviewed-by: Kees Cook <kees@ubuntu.com>

-Kees

-- 
Kees Cook
Ubuntu Security Team
