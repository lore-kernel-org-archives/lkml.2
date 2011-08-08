Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1HHRwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:52:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38921 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1HHRwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110808154027.GA4336@redhat.com>
References: <20110805204040.GG2522@redhat.com>
	<1312582209.28695.51.camel@twins>
	<20110808154027.GA4336@redhat.com>
Date: Mon, 8 Aug 2011 13:52:44 -0400
Message-ID: <CACqU3MVE4ZURooWfHDTjJ9c=VG17FNXnq6X_HBZ3+DkZeoBXJg@mail.gmail.com>
Subject: Re: [PATCH] jump label: Reduce the cycle count by changing the link order
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, rostedt@goodmis.org,
        pjt@google.com, mingo@elte.hu, rth@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 8, 2011 at 11:40 AM, Jason Baron <jbaron@redhat.com> wrote:
> On Sat, Aug 06, 2011 at 12:10:09AM +0200, Peter Zijlstra wrote:
>> On Fri, 2011-08-05 at 16:40 -0400, Jason Baron wrote:
>> [...]
>> Also, pjt mentioned on IRC that mucking about with link order is
>> something google is not unfamiliar with.. could we use some sort of
>> runtime feedback to generate linker layout maps or so? That seems like a
>> more scalable version than randomly mucking about with Makefiles :-)
>
> Agreed. Definitely a good area to research. However, until we have that done, I
> think this patch makes sense.
>
this might be a dumb question as I do not know much about that, but
couldn't hot code be put in their own section ?

Thanks,
 - Arnaud

> Thanks,
>
> -Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
