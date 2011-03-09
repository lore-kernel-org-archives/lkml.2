Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1CIJlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:41:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab1CIJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:41:34 -0500
Message-ID: <4D774B4C.7030409@suse.cz>
Date: Wed, 09 Mar 2011 10:41:32 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joe Perches <joe@perches.com>, linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: RFC: Removing old tags, reducing the git size of -next.
References: <1299039746.4208.28.camel@Joe-Laptop>	<20110302165447.f47fd4b2.sfr@canb.auug.org.au>	<4D764B59.1060801@suse.cz> <20110309032332.da40748b.sfr@canb.auug.org.au>
In-Reply-To: <20110309032332.da40748b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.3.2011 17:23, Stephen Rothwell wrote:
> Hi Michal,
> 
> On Tue, 08 Mar 2011 16:29:29 +0100 Michal Marek <mmarek@suse.cz> wrote:
>>
>> FWIW, I use the following setup for linux-next:
>>
>> [remote "linux-next"]
>>         url =
>> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> This should now be
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (its the same repository, just a more generic name).
> 
>>         fetch = +refs/heads/master:refs/heads/linux-next
>>         fetch = +refs/heads/stable:refs/remotes/linux-next/stable
>>         tagopt = --no-tags
>>
>> and fetch the next-* tags manually only when I need them.
> 
> That should all continue to work.

I probably quoted the wrong part of your email. I wanted to show that
the full history of linux-next is not forced on anyone; git can be
configured to only fetch the latest state and leave the previously
fetched states to the garbage collector.

Michal
