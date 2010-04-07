Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0DGKJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 06:09:22 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:38965 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab0DGKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 06:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Daktllmr2n6Ra6rCD0arg3n45UMhi6Mr8OqpeKMCxkOEpXHwpv60yXYUQtQzPb+j32
         TpVKcwaKgJNWVynCnf8CJMK+rKw2ssN8oxaROO3EE9K+j2u5EdjeNUay/VPERLYxTtqc
         JOGG8T5gV3FHlUOYoCmiaucWuhz3V9rhecc64=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
	 <4BBB69A9.5090906@redhat.com>
	 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
	 <20100406120315.53ad7390.akpm@linux-foundation.org>
	 <20100406194238.GB20357@a1.tnic>
	 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
	 <20100406205123.GC20357@a1.tnic>
	 <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
	 <4BBBC240.3090302@redhat.com>
	 <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org>
Date: Wed, 7 Apr 2010 13:09:14 +0300
X-Google-Sender-Auth: b05e977f66eeccf0
Message-ID: <y2u84144f021004070309rbfdc4980q67d95404567aed9b@mail.gmail.com>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 
	2.6.34-rc3)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Apr 7, 2010 at 3:10 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Sounds at least possible. Way more likely than any of the "trivially
> obvious" code being buggy, or the SLUB layer suddenly having a serious bug
> that only the new user could trigger.

I haven't followed the discussion at all but if someone wants to
investigate that angle more, the most likely suspect are the recent
per-cpu changes. That said, I'd expect the problem to be more
widespread if SLUB is to blame here.

                        Pekka
