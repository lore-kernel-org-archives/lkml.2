Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2E3UK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:10:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48003 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2E3UK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 30 May 2012 16:10:35 -0400
Message-ID: <CAHGf_=p3b8FGaxoYfO_89yZTRZ4LdTxoeoBd=Fj0Ua0aLXvPGw@mail.gmail.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        stable@vger.kernel.org, hughd@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 30, 2012 at 2:02 AM,  <kosaki.motohiro@gmail.com> wrote:
>>
>> So, I think we should reconsider about shared mempolicy completely.
>
> Quite frankly, I'd prefer that approach. The code is subtle and
> horribly bug-fraught, and I absolutely detest the way it looks too.
> Reading your patches was actually somewhat painful.

Oh, very sorry. I made effort to make smallest and simplest patches.
But I couldn't I do better. Current MPOL_F_SHARED is cra^H^H^H
complex. ;-)


> If we could just remove the support for it entirely, that would be
> *much* preferable to continue working with this code.
>
> Could we just try that removal, and see if anybody screams?

I'm keeping neutral a while and hope to hear other developers opinion.

Thank you.
