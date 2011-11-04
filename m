Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1KDUDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:03:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62686 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1KDUDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:03:48 -0400
MIME-Version: 1.0
In-Reply-To: <4EB419F5.6070308@xenotime.net>
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
	<4EB33525.808@xenotime.net>
	<4EB419F5.6070308@xenotime.net>
Date: Fri, 4 Nov 2011 22:03:47 +0200
X-Google-Sender-Auth: GDuytKtSm8eJRp2KGPmVh7zwlVo
Message-ID: <CAOJsxLGnUk9NaV2dNZH3rOMaRcCvn7Hb6w=Gn_fq9eEv2NXQnA@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 3 (KVMTOOL_TEST_ENABLE)
From: Pekka Enberg <penberg@kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        x86 maintainers <x86@kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 6:59 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 11/03/2011 05:43 PM, Randy Dunlap wrote:
>> On 11/02/2011 11:20 PM, Stephen Rothwell wrote:
>>> Hi all,
>>
>>
>> When KVMTOOL_TEST_ENABLE is enabled but CONFIG_BLOCK is not enabled, there are
>> MANY build errors.  This one (case) is probably fixed by adding "select BLOCK", but it's
>> all rather ugly.
>
> kconfig even tells us:
>
> warning: (KVMTOOL_TEST_ENABLE) selects KGDB which has unmet direct dependencies (HAVE_ARCH_KGDB && DEBUG_KERNEL && EXPERIMENTAL)
> warning: (KVMTOOL_TEST_ENABLE) selects BLK_DEV which has unmet direct dependencies (BLOCK)

Sasha, I guess your patch fixes this? Can you send me a version that
doesn't add the oldconfig magic that Ingo objected to?
