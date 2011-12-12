Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1LLWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:05:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39889 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1LLWFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:05:23 -0500
Date: Tue, 13 Dec 2011 02:05:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] [PATCH] prctl: Add PR_SET_MM codes to set up
 mm_struct entires v3
Message-ID: <20111212220518.GU2199@moon>
References: <20111212200642.836001668@openvz.org>
 <20111212201715.244414996@openvz.org>
 <CAGXu5jLSrwLeWoQNAA5uyWEewugnr1cWrxzH=wD9JnvZwgAggw@mail.gmail.com>
 <20111212205114.GR2199@moon>
 <20111212135323.2f757d9b.akpm@linux-foundation.org>
 <20111212220132.GT2199@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212220132.GT2199@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 02:01:32AM +0400, Cyrill Gorcunov wrote:
...
> > 
> > This may not be true of all compiler versions, but when I cache
> > current->mm in a local, the code size is reduced rather a lot:
> > 
> > akpm:/usr/src/25> size kernel/sys.o
> >    text    data     bss     dec     hex filename
> >   22685   14376    7616   44677    ae85 kernel/sys.o
> >   22489   14376    7616   44481    adc1 kernel/sys.o
> > 
> 
> Hmm, this is great and weird. Letme try...
> 

Same here (gcc version 4.6.2 20111027)

   text	   data	    bss	    dec	    hex	filename
  20829	  14376	   5736	  40941	   9fed	kernel/sys.o
  20682	  14376	   5736	  40794	   9f5a	kernel/sys.o

thanks Andrew!

	Cyrill
