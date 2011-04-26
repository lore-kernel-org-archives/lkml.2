Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1DZIHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:07:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50009 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1DZIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WoJOebOms/indysaNNdt8pj6XI9Pa2H4DIWE99y+WpvUOg9/keidcz1NUkr0ZJrKpT
         89aX7p1V8Phi6HQ3ILQ/e6YAxiV4njqfF9/HHymCsTOD+RwCh4uwARxkoTvFtiJ19NLz
         HOf5PyajGmzO2ceGYRd8pJbiq9f24VpLFmWww=
MIME-Version: 1.0
In-Reply-To: <20110426053150.GA11949@darkstar>
References: <20110426053150.GA11949@darkstar>
Date: Tue, 26 Apr 2011 17:07:34 +0900
Message-ID: <BANLkTimzYwa87NJ0F4AEN=9EZs=3-5SBaA@mail.gmail.com>
Subject: Re: [PATCH 2/2] use oom_killer_disabled in page fault oom path
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 2:31 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Currently oom_killer_disabled is only used in __alloc_pages_slowpath,
> For page fault oom case it is not considered. One use case is
> virtio balloon driver, when memory pressure is high, virtio ballooning
> will cause oom killing due to such as page fault oom.

Other mm guys already accepted but sorry I can't understand your point
since I am not familiar with virtio.

Now oom_killer_disabled is used by only hibernation and hibernation
freezes processes so page fault shouldn't happen.

Now are you using oom_killer_disabled in virtio?
Could you elaborate use case ?

Thanks.
-- 
Kind regards,
Minchan Kim
