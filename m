Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892Ab0FQXM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:12:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0FQXM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:12:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cyhVlZLw5f1gWBEf3WATYxNmLVvgvUNaOoY8ZRmDgRZQitdHh4gAKdk92cRewcN5V
	tqqet36x9tp023pJTmopQ==
MIME-Version: 1.0
In-Reply-To: <20100618090857.057e0a7a.sfr@canb.auug.org.au>
References: <AANLkTikXH_UtE95ZGHp5AAm5IRD6dN8cnrNK9A3-MRwY@mail.gmail.com>
	<20100618090857.057e0a7a.sfr@canb.auug.org.au>
Date: Thu, 17 Jun 2010 16:12:23 -0700
X-Google-Sender-Auth: oK1Fq4eycYALzI3jeC-Jh0CJ7_4
Message-ID: <AANLkTin7ZT5YyL7vUjiQ-5s9wjmEWEqfw7tnaHP4k5U_@mail.gmail.com>
Subject: Re: [GIT PULL linux-next] tegra
From: Erik Gilling <konkers@android.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
       Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen,
    Add Colin and Olof as contacts as well.

Cheers,
    Erik

On Thu, Jun 17, 2010 at 4:08 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Eric,
>
> On Thu, 17 Jun 2010 15:38:19 -0700 Erik Gilling <konkers@android.com> wrote:
>>
>> Can you please pull the following into linux-next?
>>
>> git://android.git.kernel.org/kernel/tegra.git for-next
>>
>> This tree adds support for the Nvidia Tegra ARM SOCs.  It's received
>> review on linux-arm-kernel.
>
> Added from today.  Should the contact be just you or should I add others
> as well.
>
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
>
> You will need to ensure that the patches/commits in your tree/series have
> been:
>     * submitted under GPL v2 (or later) and include the Contributor's
>        Signed-off-by,
>     * posted to the relevant mailing list,
>     * reviewed by you (or another maintainer of your subsystem tree),
>     * successfully unit tested, and
>     * destined for the current or next Linux merge window.
>
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
>
> --
> Cheers,
> Stephen Rothwell
> sfr@canb.auug.org.au
>
> Legal Stuff:
> By participating in linux-next, your subsystem tree contributions are
> public and will be included in the linux-next trees.  You may be sent
> e-mail messages indicating errors or other issues when the
> patches/commits from your subsystem tree are merged and tested in
> linux-next.  These messages may also be cross-posted to the linux-next
> mailing list, the linux-kernel mailing list, etc.  The linux-next tree
> project and IBM (my employer) make no warranties regarding the linux-next
> project, the testing procedures, the results, the e-mails, etc.  If you
> don't agree to these ground rules, let me know and I'll remove your tree
> from participation in linux-next.
>
