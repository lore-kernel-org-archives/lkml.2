Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2GYPgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:36:23 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:32607 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750918Ab2GYPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:36:21 -0400
Message-ID: <5010126D.9030205@keymile.com>
Date: Wed, 25 Jul 2012 17:36:13 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the mtd tree
References: <20120717110025.35e6d8404104e77019bef6ce@canb.auug.org.au> <50100EDC.3010109@keymile.com> <1343230004.14051.67.camel@shinybook.infradead.org>
In-Reply-To: <1343230004.14051.67.camel@shinybook.infradead.org>
Content-Type: text/plain;
	charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2012 15:36:13.0817 (UTC) FILETIME=[39483E90:01CD6A7B]
X-ESAFE-STATUS: [srvchber1306.keymile.net] Mail allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 07/25/2012 05:26 PM, David Woodhouse wrote:
> On Wed, 2012-07-25 at 17:21 +0200, Gerlando Falauto wrote:
>>
>> So could someone please spend a few words on what happened in the meantime?
>> To me it looks like the l2-mtd tree got rebased at some point, but I'm
>> quite at loss about this whole back-and-forth between trees.
>> I'm sure a few words could make my life much easier... :-)
>
> There's no need to worry. The l2-mtd tree is rebased on top of the mtd
> tree, and contains patches that Artem thinks I'm likely to accept.
>
> I apply them, sometimes with a few minor changes, or I occasionally
> reject them. Sometimes if Artem doesn't *immediately* update his tree
> after I push changes to mine, a 'conflict' appears between the two. You
> can ignore it.
>

thanks for your explanation.
So, is it correct to say that any patch contained within l2-mtd (but 
*NOT* within linux-mtd) will eventually be killed? (Or rather, 
*replaced* by the version eventually applied to linux-mtd)?
In other words, when you say "Artem updates his tree", it is technically 
a rebase (so his version of a patch actually looks as if never existed), 
right?

Thanks a lot!
Gerlando
