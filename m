Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2BCVBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:01:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59502 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab2BCVB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:01:29 -0500
Message-ID: <4F2C4AE1.70309@zytor.com>
Date: Fri, 03 Feb 2012 13:00:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org> <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu> <20120203125715.0e9dfb1d.akpm@linux-foundation.org>
In-Reply-To: <20120203125715.0e9dfb1d.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 12:57 PM, Andrew Morton wrote:
> 
> If we really want to improve the world we should jump into a time
> machine and set tabstops to 4.  Sigh.
> 

Most editors these days will happy do 4-space stops expanded to 8-space
tab characters.

I have adopted the "Linux kernel formatting with 4-space indentation"
for most of my projects these days.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

