Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2BPTXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:23:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab2BPTXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:23:39 -0500
Message-ID: <4F3D56F4.3020401@zytor.com>
Date: Thu, 16 Feb 2012 11:20:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
References: <20120215195733.GA8021@albatros> <20120215200533.GQ1894@moon> <20120215202538.GK4533@moon> <20120215210934.GL4533@moon> <20120215215807.GM4533@moon> <20120216144954.GA11953@redhat.com> <20120216151340.GI1905@moon> <20120216164901.GD3849@moon> <20120216174047.GA31176@redhat.com> <20120216175809.GJ1905@moon> <20120216190321.GA2216@redhat.com>
In-Reply-To: <20120216190321.GA2216@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 11:03 AM, Oleg Nesterov wrote:
> 
> so let me repeat, I am not arguing. But IMHO every piece of code
> should be understandable.

Amen!

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

