Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2BOHEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:04:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40520 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2BOHEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:04:32 -0500
Date: Wed, 15 Feb 2012 11:04:27 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
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
Message-ID: <20120215070427.GE1894@moon>
References: <20120213164822.227219834@openvz.org>
 <20120213165137.903318774@openvz.org>
 <20120214151312.92afd44a.akpm@linux-foundation.org>
 <20120215065245.GB1894@moon>
 <bb6e15c8-1b6b-4809-a796-cdfac39bc8b4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6e15c8-1b6b-4809-a796-cdfac39bc8b4@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:55:55PM -0800, hpanvin@gmail.com wrote:
>
> What?  <linux/unistd.h> should be used, and it should handle
> the inclusions.
>

Peter, I maybe missing something which directories I should
add to -I option, letme recheck (but without headers_intall
target the syscall number is unresolved for me).

	Cyrill
