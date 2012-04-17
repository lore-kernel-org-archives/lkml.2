Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2DQWjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:39:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34460 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DQWji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:39:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6ugOsCNRD2Jqyv-gf8X4Dvd012Gn5RyBq4TQBBb86W1qg@mail.gmail.com>
References: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
 <20120412103157.70669ff82b81d5d926c36d4d@canb.auug.org.au>
 <CACxGe6tDa+AzK0O=E+EPZ90Ek_C-rM-G4fHSnsdL0S+fNcmzmw@mail.gmail.com>
 <20120417132357.b38685ea31582e638623961c@canb.auug.org.au> <CACxGe6ugOsCNRD2Jqyv-gf8X4Dvd012Gn5RyBq4TQBBb86W1qg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Apr 2012 16:39:16 -0600
X-Google-Sender-Auth: 51AO-5DlPEprHAPYHeiG6yqzd-M
Message-ID: <CACxGe6ua4ev7-8Mvmvu4UKfGY12g0mTY-uAmRqcZnpFZnA_70w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 9:39 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Apr 16, 2012 at 9:23 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Grant,
>>
>> On Wed, 11 Apr 2012 18:35:34 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>>>
>>> On Wed, Apr 11, 2012 at 6:31 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> > Hi Grant,
>>> >
>>> > On Wed, 11 Apr 2012 15:11:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> >>
>>> >> After merging the final tree, today's linux-next build (sparc64 defconfig)
>>> >> failed like this:
>>> >>
>>> >> drivers/of/of_mdio.c: In function 'of_mdiobus_register':
>>> >> drivers/of/of_mdio.c:75:4: error: implicit declaration of function 'irq_of_parse_and_map' [-Werror=implicit-function-declaration]
>>> >>
>>> >> Caused by commit e46c11b94787 ("of/irq: add empty irq_of_parse_and_map()
>>> >> for non-dt builds").  SPARC has CONFIG_OF but not CONFIG_OF_IRQ ...
>>> >>
>>> >> I have reverted that commit for today.
>>> >
>>> > That commit is actually in the devicetree-current tree.
>>>
>>> Yes, drop that tree or revert that commit.  There's nothing else in
>>> there and I didn't have time to pull it back today before you started
>>> linux-next for the day.  The change is bogus and I'll spin a proper
>>> fixup for tomorrow.
>>
>> Ping?
>
> Haven't got it done yet.  It's still safe to ignore that tree.

Should be fixed now.

g.
