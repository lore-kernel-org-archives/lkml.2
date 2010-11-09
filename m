Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0KICPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:15:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53456 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0KICO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aQmaYMNa/XGou8/LhCwy97LVUREesSA1ryrbmohfK++52PTXiihmYrZBKQ/EmqsI1h
         9flbR41zORiauXRiCyijWIQuWsSnkCv2XOsXL5rZiriQ2fte/LcIwBQfUN2EEU3NVoLs
         DhbFD7Mg3eS+2Njobxfb6ndswNGn/j3ymIgnA=
MIME-Version: 1.0
In-Reply-To: <20101108130543.1188a63f.akpm@linux-foundation.org>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
	<1289069918-2085-2-git-send-email-tdent48227@gmail.com>
	<EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com>
	<20101108130543.1188a63f.akpm@linux-foundation.org>
Date: Mon, 8 Nov 2010 21:14:58 -0500
Message-ID: <AANLkTi=fY6jxCw46zZWoX+eRvk8CaV+nwY=GaoMqFWbC@mail.gmail.com>
Subject: Re: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the
 use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ed Cashin <ecashin@coraid.com>, sage@newdream.net, yehuda@hq.newdream.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/10, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 8 Nov 2010 10:03:24 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
>
>> On Nov 6, 2010, at 2:58 PM, Tracey Dent wrote:
>>
>> > Changed <module>-objs to <module>-y in Makefile.
>>
>> Andrew Morton, hi.  I don't know whether Tracey Dent is expecting
>> me to push this change to Linus, but lately you've been pushing the
>> aoe changes.  I see similar changes in other
>> drivers on the LKML, so if it looks good to you, would you mind please
>> picking up this patch?
>
> I queued both patches - I guess I'll send them to Jens.
>
> I queued them as "unchangelogged patches".  Because what the changelogs told
> us was utterly obvious from reading the patch.
>
> What the changelogs didn't tell us was _why_ the change was made.  And
> guess what?  I don't have a clue!  I just haven't been following these
> kbuild minutea.
>
> Tracey, please send a description of *why* this change is being made
> and I'll add it to the changelogs.  Please include that explanation in
> all such patches.
>

Is this good?

Changed Makefile to use <modules>-y instead of <modules>-objs because -objs is
deprecated and should now be switched. According to
(documentation/kbuild/makefiles.txt).

regards

td
