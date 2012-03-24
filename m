Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2CXANY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:13:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36553 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2CXANY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120323202713.GA6039@redhat.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com> <20120323202713.GA6039@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 23 Mar 2012 18:12:51 -0600
Message-ID: <CAJfuBxztMMUrbUvVft8gXB4Jk2yi+AXVV-TVLXAFdtgMf4AUgg@mail.gmail.com>
Subject: Re: [00/11] pr_debug during module initialization
To: Jason Baron <jbaron@redhat.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 2:27 PM, Jason Baron <jbaron@redhat.com> wrote:
> On Wed, Mar 14, 2012 at 05:01:55PM -0600, jim.cromie@gmail.com wrote:
>> This is 3rd revision of the dyndbg modinit patches, previously sent
>> Dec 11.  Patches 1-17/25 sent then were added to driver-core-next,
>> this set reworks the remainder.
>>
>> It implements the "fake" module param approach proposed by
>> Thomas Renninger, back in https://lkml.org/lkml/2010/9/15/397
>>
>
> Hi,
>
> I'm wondering, if we leave the cmdline parameter: 'ddebug_query=' around
> for a bit before removing it, so it doesn't get dropped too suddenly.
> Perhaps, we add a warning msg, for people that are still using it
> for a few releases warning that it is deprecated, before dropping it.
>

OK, thats reasonable.  I'll explicitly deprecate it in
Doc/feature-removal-schedule.  What is the default
deprecation time, 2 releases ?

Assuming this patchset is for 3.4, I'll say 3.6 unless someone disagrees.

> Also, let's add the 'dyndbg=' syntax to Documentation/kernel-parameters.txt.
>

oops.  that got dropped accidentally.

> A previous version had a build-time error if a module used 'dyndbg' as a
> module param - why did that get dropped?

Rusty expressed view that if developers add it, they meant it.
He also said the macro was redundant with another,
but I didnt look further cuz of the 1st point.


>
> Thanks!
>
> -Jason
