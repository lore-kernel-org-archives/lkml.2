Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2BOWAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:00:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53965 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2BOWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:00:44 -0500
Date: Thu, 16 Feb 2012 02:00:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "hpanvin@gmail.com" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [patch 2/4] syscalls, x86: Add __NR_kcmp syscall v8
Message-ID: <20120215220040.GA26668@moon>
References: <20120213164822.227219834@openvz.org>
 <20120213165137.903318774@openvz.org>
 <20120214151312.92afd44a.akpm@linux-foundation.org>
 <20120215065245.GB1894@moon>
 <bb6e15c8-1b6b-4809-a796-cdfac39bc8b4@email.android.com>
 <20120215070427.GE1894@moon>
 <20120215072454.GA4533@moon>
 <20120215135313.0e22d1bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215135313.0e22d1bf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 01:53:13PM -0800, Andrew Morton wrote:
> That worked.
> 
> What's with all those warnings, btw?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix
> 
> kcmp_test.c: In function 'main':
> kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 4 has type 'long int'

Indeed it's nit, wonder why I've not beed warned by compiler before
(nothing serious since results do fit integer anyway but _must_
 be fixed). I'll update shortly. Sorry for that.

	Cyrill
