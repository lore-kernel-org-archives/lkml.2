Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1BKNoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:44:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab1BKNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:44:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DzOpGMtwY+3860QgceLXKJ7lye61u1xfmVnbJRdZyx/GfeHqSQW38Idw0YgxCgiJMf
         6S4FjWkjfEJGhrwGGk5qyP8SzNhJ+eLrUe8MDk1FPvVuMnMnwnVCw3I6/Sb2XIcb53BG
         wB1ucwNay8DUPb6Oxe4AtITxDAAL8ghfKkox8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
References: <201102091608.59448.rusty@rustcorp.com.au>
	<20110210124416.GE26094@elte.hu>
	<201102110802.17453.rusty@rustcorp.com.au>
	<alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
	<AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
Date: Fri, 11 Feb 2011 15:44:35 +0200
Message-ID: <AANLkTi=1U62tqK0CdUZjJ9D_ZKhUD08+i4wrQPqrexgC@mail.gmail.com>
Subject: Re: [PULL] cpumask offstack finalization
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, anton@samba.org,
        Mike Travis <travis@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 1:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So never _ever_ mark anything "deprecated". If you want to get rid of
> something, get rid of it and fix the callers.

Does this apply to drivers/staging/ ?
