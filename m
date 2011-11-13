Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1KMOuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 09:50:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53026 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1KMOum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 09:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111113231944.4677bd7a2154975c989663ab@canb.auug.org.au>
References: <CAA_GA1f8+6bqXGXo33GDbJmXvaqdD-qMUh=ejx0+Ag-shmc0uw@mail.gmail.com>
	<20111113231944.4677bd7a2154975c989663ab@canb.auug.org.au>
Date: Sun, 13 Nov 2011 22:50:41 +0800
Message-ID: <CAA_GA1fFspdayjpLNpm1C-kPug6n7LXyJ0dqiX=3d_gHt2U9xg@mail.gmail.com>
Subject: Re: Blackfin.git tree change
From: Bob Liu <lliubbo@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>, sonic.zhang@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen

On Sun, Nov 13, 2011 at 8:19 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bob,
>
> On Fri, 11 Nov 2011 18:49:59 +0800 Bob Liu <lliubbo@gmail.com> wrote:
>>
>> I'll take most of the arch Blackfin maintain work from now on.
>>
>> My tree is:
>> git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git#for-linus
>>
>> Would you please update it for linux-next.
>
> OK, I have switched to that tree and will put you as the contact.  Should
> I also keep Mike as a contact for problems with this tree?
>

Yes, Please.

> The only thing I did notice, is that this commit was in Mike's tree but
> is not in yours:
>
> Author: Sonic Zhang <sonic.zhang@analog.com>
> Date:   Mon Aug 1 17:53:21 2011 +0800
>
>    Blackfin: add serial TX IRQ in individual platform resource
>
>    The serial TX IRQ is not simply (RX IRQ + 1) on some Blackfin chips,
>    so move the values to the platform resources.
>
>    Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Just in case it was forgotten.
>

Sorry for that, I thought that patch has been merged to mainline.
I'll update it soon. Thanks.

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

-- 
Regards,
--Bob
