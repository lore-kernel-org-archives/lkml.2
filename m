Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0C2TGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:06:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41467 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0C2TG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RS6EnVf7026n0O9AGnn+57OAAYelhh5+2327qau4lTrvOXMU4GjzKCV+FVyiM8OwCo
         jMzuQngythBxFQIaux2HYl2IjMVc2LpsAjnzDrpnop53Evop/G9ZaP/a1KqGknpHVYtl
         UxgH67q5LiYFkGqqSVFhg7v77MgDOLtXw/nxo=
MIME-Version: 1.0
In-Reply-To: <20100329185652.GH5101@nowhere>
References: <1269866171-7331-2-git-send-email-jkacur@redhat.com>
	 <1383519680.42441269869622199.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
	 <20100329185652.GH5101@nowhere>
Date: Mon, 29 Mar 2010 21:06:27 +0200
X-Google-Sender-Auth: 2b8637a7cda9825a
Message-ID: <520f0cf11003291206i7fae62b7ie7d0e480237aa1f2@mail.gmail.com>
Subject: Re: [PATCH] nvram: Convert nvram_ioctl to unlocked_ioctl, remove 
	smp_lock.h
From: John Kacur <jkacur@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 8:56 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Mar 29, 2010 at 09:33:42AM -0400, John Kacur wrote:
>> Sorry for the double send, I must have messed-up something with
>> git-send-email. The --compose failed on me, and that part of the message was
>> lost afaict.
>>
>> What I wanted to say was, Ingo, in the past you carried nvram fixes, so
>> if no-one objects to this change, can you integrate this one?
>
>
>
> Note: Just in case, as I don't know if Ingo or Thomas still maintain
> a kill-bkl tree, I keep this patch somewhere so that if it's not merged
> in a tree in one week or so, I'll queue it up in mine.
>

In this particular case, I would like to see it get tip testing though.

Thanks.
