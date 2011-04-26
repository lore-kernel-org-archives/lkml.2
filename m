Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1DZIVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:21:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1DZIVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BMkO5k6VFg3liX/SutbGr6lP5Q7jUuQDY9URjzeaptR+Cp4JBx089PcQrjI/r5/8c5
         nHveTVp9TG83IZUG+g/IiUvoDtqkGmLCCreIBeGxAMAujT/ea3Vh19OCrRCJC5iUAKXl
         gBrE9E2dHYG48OmyfUNo4r2i57+bbuHWZoiFY=
MIME-Version: 1.0
In-Reply-To: <BANLkTimzYwa87NJ0F4AEN=9EZs=3-5SBaA@mail.gmail.com>
References: <20110426053150.GA11949@darkstar>
	<BANLkTimzYwa87NJ0F4AEN=9EZs=3-5SBaA@mail.gmail.com>
Date: Tue, 26 Apr 2011 17:21:48 +0900
Message-ID: <BANLkTingHBoK4mtsHkhZxW=p1GcxCjzRsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] use oom_killer_disabled in page fault oom path
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 5:07 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 2:31 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> Currently oom_killer_disabled is only used in __alloc_pages_slowpath,
>> For page fault oom case it is not considered. One use case is
>> virtio balloon driver, when memory pressure is high, virtio ballooning
>> will cause oom killing due to such as page fault oom.
>
> Other mm guys already accepted but sorry I can't understand your point
> since I am not familiar with virtio.
>
> Now oom_killer_disabled is used by only hibernation and hibernation
> freezes processes so page fault shouldn't happen.
>
> Now are you using oom_killer_disabled in virtio?
> Could you elaborate use case ?

Sorry, I lost your [1/2] in my mail box.
I will see it in marc linux-mm

-- 
Kind regards,
Minchan Kim
