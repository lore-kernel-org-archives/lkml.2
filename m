Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1KFUKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:10:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33288 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:10:18 -0500
MIME-Version: 1.0
In-Reply-To: <CANK3SE0Ehuytj2VCMiQbu+EHZqDZO7jBBaMb3AORVsC_DsSTVA@mail.gmail.com>
References: <1320591562-11839-1-git-send-email-jonas.gorski@gmail.com> <CANK3SE0Ehuytj2VCMiQbu+EHZqDZO7jBBaMb3AORVsC_DsSTVA@mail.gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sun, 6 Nov 2011 21:09:55 +0100
Message-ID: <CAOiHx=nHOR+f_GGm4cd4iMB52ohOP-+Fe+w_bPNC5oiBP2+4bw@mail.gmail.com>
Subject: Re: [PATCH] staging: et131x: fix build failure with PM_SLEEP disabled
To: Mark Einon <mark.einon@gmail.com>
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 6 November 2011 19:47, Mark Einon <mark.einon@gmail.com> wrote:
>   This issue has already been fixed by an earlier patch. See
> https://lkml.org/lkml/2011/11/4/245 .

Ah, great :-) So please disregard this patch. (Ah, I missed yours
since it seems to have gone only to LKLM, not to devel; at least I
don't see it in my local archive).

Regards,
Jonas
