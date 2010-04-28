Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0D1NsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:48:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37208 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0D1NsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q4c2gAPoufklHKfxW1ewzsDq3jbjDfNcruvpZJdvFcldZSlLtrlxl6SESsCdkfSZ7S
         t6qcNakAaHLSvfXjECgkNRHSwIroWWvkbljNvlBUf3TnR2oVtGX13TqYyLvU6bwoX7Tj
         KQzStZeSBjapyZBn36B9gHayIkV3CF45U/q3s=
MIME-Version: 1.0
In-Reply-To: <8566.1272447243@redhat.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<8566.1272447243@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 21:47:36 +0800
Message-ID: <p2t412e6f7f1004280647y42b06418m4734e74a4628b6bd@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 5:34 PM, David Howells <dhowells@redhat.com> wrote:
>
> Can you split the wait queue code and differentiate exclusive wait queues with
> LIFO functionality from wait queues with FIFO functionality.  I can see why
> your suggestion is desirable.
>

OK. I will use two lists: one for non-exclusive wait queues, and the
other for exclusive wait queues, and I'll add new interfaces for LIFO
functionality instead of changing the current interfaces.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
