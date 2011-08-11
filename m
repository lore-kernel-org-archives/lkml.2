Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1HKRPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:15:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42422 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HKRPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E43D4AD.6080702@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com>
 <20110802183019.GB8393@windriver.com> <CAMjpGUcOagn-o_mETLDr-=pa-3sxq_iDjF=A8OGhdJg5+9ewpA@mail.gmail.com>
 <4E42D769.8030704@windriver.com> <CAMjpGUcTMwYs99Nu02u+Sbg99RuJvRDpjvY6ChDLUEASf1wUrA@mail.gmail.com>
 <4E43D4AD.6080702@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 11 Aug 2011 13:15:17 -0400
Message-ID: <CAMjpGUch3O_DWKv39A_H91bU5ypSxSgHjSVX8WYDnGxKVBPZLQ@mail.gmail.com>
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

On Thu, Aug 11, 2011 at 09:10, Paul Gortmaker wrote:
> On 11-08-11 12:34 AM, Mike Frysinger wrote:
>> On Wed, Aug 10, 2011 at 15:09, Paul Gortmaker wrote:
>>> Have you thought about getting at least one blackfin defconfig in
>>> the linux-next build coverage?  Gives you a better chance of
>>> having people see when they've broken it.
>>
>> all of the blackfin defconfigs get tested nightly in linux-next by an
>> ADI build machine.  i just didnt have a chance to review the logs as i
>> was traveling.
>
> That is good, but as you've noted, it isn't something that anyone
> else can see when they are combing the normal linux-next build
> results below looking to see if they broke anything.
>
> http://kisskb.ellerman.id.au/kisskb/branch/9/

ive never heard of this site before, and there doesnt appear to be any
documentation on that site about it
-mike
