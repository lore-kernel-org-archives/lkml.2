Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1KNK2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:28:40 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:17382 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1KNK2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:28:39 -0500
Message-ID: <4EC0ED51.8030702@parallels.com>
Date: Mon, 14 Nov 2011 14:28:33 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com> <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com> <4EBD4ACB.2070001@parallels.com> <20111111162200.GA24737@google.com> <4EBD522E.2000203@parallels.com> <20111111170244.GB24737@google.com> <4EBD57D4.1060503@parallels.com> <20111113192848.GC4633@redhat.com>
In-Reply-To: <20111113192848.GC4633@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hm, so intrusiveness is your main concern here, I see.
> 
> To me, this is important.
> 
> Let me repeat. It is not that I strongly against CLONE_CHILD_USEPIDS
> (although yes, I can't say personally I like it very much ;). Just
> I am trying to ensure we can't make something more clear/clean/simple,
> at least from the kernel pov. Especially because you are trying to
> establish the new user-visible API.

OK, I see. I think I will fix your comment then and will send the v2 set trying
to get the feedback from wider audience. Oleg, Tejun, thank you for your ;)

> Oleg.

