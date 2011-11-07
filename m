Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1KGJqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:46:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65336 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1KGJqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:46:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAOiHx=nHOR+f_GGm4cd4iMB52ohOP-+Fe+w_bPNC5oiBP2+4bw@mail.gmail.com>
References: <1320591562-11839-1-git-send-email-jonas.gorski@gmail.com>
 <CANK3SE0Ehuytj2VCMiQbu+EHZqDZO7jBBaMb3AORVsC_DsSTVA@mail.gmail.com> <CAOiHx=nHOR+f_GGm4cd4iMB52ohOP-+Fe+w_bPNC5oiBP2+4bw@mail.gmail.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Mon, 7 Nov 2011 09:45:57 +0000
Message-ID: <CANK3SE1KjaJu0aP686qT5NVtQjVGW=UvfeqUsijrps3CG2O-QQ@mail.gmail.com>
Subject: Re: [PATCH] staging: et131x: fix build failure with PM_SLEEP disabled
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 November 2011 20:09, Jonas Gorski <jonas.gorski@gmail.com> wrote:
> Hi Mark,
>
> On 6 November 2011 19:47, Mark Einon <mark.einon@gmail.com> wrote:
>>   This issue has already been fixed by an earlier patch. See
>> https://lkml.org/lkml/2011/11/4/245 .
>
> Ah, great :-) So please disregard this patch. (Ah, I missed yours
> since it seems to have gone only to LKLM, not to devel; at least I
> don't see it in my local archive).

Yes, you're right, I didn't send it to devel.
I believe there are other patches outstanding for et131x that mean
that this patch wouldn't apply.
I aim to look at fixing the staging tree in the next few days, unless
someone else gets there first.

cheers,

Mark
