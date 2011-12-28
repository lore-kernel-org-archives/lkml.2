Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1L1HY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:24:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34306 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1L1HYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:24:25 -0500
Date: Wed, 28 Dec 2011 11:24:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228072420.GB27266@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111227153304.c585c5f6.akpm@linux-foundation.org>
 <4EFA6751.3060502@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFA6751.3060502@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 04:48:17PM -0800, Randy Dunlap wrote:
...
> > 
> > Is c/r useless without GENERIC_OBJECT_ID?  If so, perhaps a `select'
> > would be good here.
> 
> Is GENERIC_OBJECT_ID useful elsewhere?  If so, then it shouldn't depend
> on CHECKPOINT_RESTORE -- it should just live in lib/ instead of in mm/
> and CHECKPOINT_RESTORE should select it.
> 

Well, at moment I simply don't know who else might need it. So I though
that if someone would need it we simply drop CHECKPOINT_RESTORE dep then.

	Cyrill
