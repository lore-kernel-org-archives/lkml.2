Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab2EVLDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:03:40 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44402 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab2EVLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <1337661655.2779.167.camel@pasglop>
References: <1337651473.2779.140.camel@pasglop>
	<1337661655.2779.167.camel@pasglop>
Date: Tue, 22 May 2012 07:03:38 -0400
Message-ID: <CA+5PVA5g-XLdwaxSLAAuArcRMeZ43WR8pBZZkjdNd79Tr6EQ_w@mail.gmail.com>
Subject: Re: powerpc -next rebase WARNING
From: Josh Boyer <jwboyer@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:40 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2012-05-22 at 11:51 +1000, Benjamin Herrenschmidt wrote:
>> Folks, bad news ... my fault.
>>
>> I accidentally forgot a --signoff on a git am command last week, meaning
>> that a pair of patches are in -next and not signed off by me.
>>
>> For various (legal) reasons that cannot go into Linus tree as-is, so I
>> have to rebase the tree to fix it.
>>
>> Sorry about that ...
>
> Note that the rebase only affects the top 3 commits, so if your
> tree is based on something older you're fine (Kumar, you seem to
> be ok, I haven't checked Josh).

Should be fine.  Even if not, all 4 of its users will manage to cope.

josh
