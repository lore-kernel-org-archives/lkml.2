Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1L1AC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 19:02:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1L1AC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 19:02:26 -0500
Date: Tue, 27 Dec 2011 16:02:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-Id: <20111227160224.c59080e6.akpm@linux-foundation.org>
In-Reply-To: <249444.1325030069@turing-police.cc.vt.edu>
References: <20111223124741.711871189@openvz.org>
	<20111223124920.661126615@openvz.org>
	<249444.1325030069@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 18:54:29 -0500
Valdis.Kletnieks@vt.edu wrote:

> > +config GENERIC_OBJECT_ID
> > +	bool "Enable generic object ID infrastructure"
> > +	depends on CHECKPOINT_RESTORE
> > +	default n
> > +	help
> > +	  Turn on the functionality that can generate IDs for kernel
> 
> "Turn on functionality"
> 
> > +	  objects, which are exported to userspace via /proc filesystem.
> 
> Lose the ,
> 
> > +
> > +	  It is useful if you need to examinate kernel objects and test
> 
> examine
> 
> > +	  if they are shared between several tasks. These IDs should never
> > +	  be used for anything but the "sameness" test. Besides, the IDs are
> 
> s/Besides, the/The/
> 
> > +	  dynamic and valid only while object is alive, once it get freed or
> 
> s/alive, once/alive. Once/
> 
> > +	  kernel is rebooted -- the IDs will be changed.
> 
> s/ --/,/

heh, I avoided mentioning these things because I usually rewrite the
user-facing text when merging patches from non-native English speakers.

