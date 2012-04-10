Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab2DJWlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:41:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51417 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2DJWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:41:14 -0400
Message-ID: <4F84B6B9.9080701@zytor.com>
Date: Tue, 10 Apr 2012 15:39:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon> <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <20120409222443.GW1625@moon> <4F836F3E.9090207@zytor.com> <20120410223758.GL24857@moon>
In-Reply-To: <20120410223758.GL24857@moon>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 03:37 PM, Cyrill Gorcunov wrote:
> + * bits even more (the oddity is important here, it allow
> + * us to have meaningful production even if multiplicants
> + * are big numbers).

I would be more clear:

"the odd multiplier guarantees that the product is unique ever after the
high bits are truncated, since any odd number is relative prime to 2^n".

	-hpa

