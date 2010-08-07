Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534Ab0HGCzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:55:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61033 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762502Ab0HGCyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <20100807100123.886d3a1e.sfr@canb.auug.org.au>
References: <20100806183839.32149.6238.stgit@angua> <20100807100123.886d3a1e.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 6 Aug 2010 20:54:34 -0600
X-Google-Sender-Auth: SXPSPT61iEofMNMUbdefHelKSBQ
Message-ID: <AANLkTikt5xR0jYL_m6+vO2bkcxSBA8DwffRDbDae8OmA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: fix i8042 module build error
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: martyn.welch@ge.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 6:01 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Fri, 06 Aug 2010 12:42:12 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> of_i8042_{kbd,aux}_irq needs to be exported
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> Stephen and Ben, this fixes up the build error in linux-next.  If you prefer,
>> I can stuff this patch into my next-powerpc branch.  Ben, I've got other
>> commits in that branch that I'll be sending to you early next week anyway.
>
> This failure also exists in Linus' tree, so the earlier this goes to
> Linus the better.

Okay then.  Ben, I'll send out my pull request out right away so
you've got it if you want to use it.

Cheers,
g.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
