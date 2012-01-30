Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2A3VMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:12:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49775 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2A3VMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:12:49 -0500
Message-ID: <4F270794.8030202@zytor.com>
Date: Mon, 30 Jan 2012 13:11:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org> <20120130125812.0075dd04@dt>
In-Reply-To: <20120130125812.0075dd04@dt>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 11:58 AM, Jonathan Corbet wrote:
> 
> That's a cute trick, but do we know that every compiler that will ever see
> this code will use 1 for a true integer comparison?  Simply spelling it
> out with an if statement might be more robust, just as efficient, and, at
> the same time, easier for others to understand.
> 

This has been the case in C from the very beginning and is guaranteed by
the C standard.  The number of places which will break if this isn't
true is enormous.

	-hpa

