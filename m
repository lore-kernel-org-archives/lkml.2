Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1HKEfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 00:35:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34266 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HKEfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 00:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E42D769.8030704@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com>
 <20110802183019.GB8393@windriver.com> <CAMjpGUcOagn-o_mETLDr-=pa-3sxq_iDjF=A8OGhdJg5+9ewpA@mail.gmail.com>
 <4E42D769.8030704@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 11 Aug 2011 00:34:55 -0400
Message-ID: <CAMjpGUcTMwYs99Nu02u+Sbg99RuJvRDpjvY6ChDLUEASf1wUrA@mail.gmail.com>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 15:09, Paul Gortmaker wrote:
> On 11-08-07 10:42 PM, Mike Frysinger wrote:
>
> [...]
>
>> Blackfin is broken because of this.  a simple grep of the tree
>
> I've run all the in-tree blackfin configs, so it is all good.

so you made a change and it's all good <now> ?

> Have you thought about getting at least one blackfin defconfig in
> the linux-next build coverage?  Gives you a better chance of
> having people see when they've broken it.

all of the blackfin defconfigs get tested nightly in linux-next by an
ADI build machine.  i just didnt have a chance to review the logs as i
was traveling.
-mike
