Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1HOMhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:37:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33791 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1HOMhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:37:47 -0400
Message-ID: <4E4912F0.8030705@parallels.com>
Date: Mon, 15 Aug 2011 16:37:04 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <jbottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>	<1313334832-1150-4-git-send-email-glommer@parallels.com>	<CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>	<20110815104656.GG26978@dastard>	<CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>	<4E48FD8A.90401@parallels.com>	<CAOJsxLFjZffC9i5kQsBWjGy3eWdj3VMB5awz=yPcwgeKb5BG0Q@mail.gmail.com>	<4E4903C1.9050207@parallels.com>	<CAOJsxLErFcxuuqnWkRbOAHEFbeGrKp3YMZ-144=m16oBXCHJ2g@mail.gmail.com>	<4E490D47.8050105@parallels.com> <CAOJsxLEVfGrzUQv0fOpOyw3AaOLOHcWbvLJL1NdrHS6M2j5o1g@mail.gmail.com>
In-Reply-To: <CAOJsxLEVfGrzUQv0fOpOyw3AaOLOHcWbvLJL1NdrHS6M2j5o1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, this patchset does only the API part. The full idea is implemented (with poor API though) here:
>> http://lwn.net/Articles/441164/
> 
> OK. I suppose it's best to keep it separate of the slab code for now
> then. Maybe you're able to come with something more generic that we
> could make part of slab APIs later.

Yup! We also have plans for having control over the kernel memory usage by containers, so
we'll certainly get back to it :)

>                             Pekka
> .
> 

