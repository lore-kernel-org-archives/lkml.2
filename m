Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab2JWUW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:22:28 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49401 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2JWUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121023.161630.969990145069865276.davem@davemloft.net>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-174-git-send-email-keescook@chromium.org>
	<1351023350.10322.21.camel@jlt4.sipsolutions.net>
	<20121023.161630.969990145069865276.davem@davemloft.net>
Date: Tue, 23 Oct 2012 13:22:23 -0700
X-Google-Sender-Auth: 9wZiKZjEkk6EMtUaHM7AQLK9CNg
Message-ID: <CAGXu5j+wRzsYy1WWo5tbffz6p0hnRAkS+DV3Jv1e35ppGFrchA@mail.gmail.com>
Subject: Re: [PATCH 173/193] net/mac80211: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:16 PM, David Miller <davem@davemloft.net> wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 23 Oct 2012 22:15:50 +0200
>
>> On Tue, 2012-10-23 at 13:04 -0700, Kees Cook wrote:
>>> This config item has not carried much meaning for a while now and is
>>> almost always enabled by default. As agreed during the Linux kernel
>>> summit, remove it.
>>>
>>> CC: "John W. Linville" <linville@tuxdriver.com>
>>> CC: Johannes Berg <johannes@sipsolutions.net>
>>> CC: "David S. Miller" <davem@davemloft.net>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>>
>> Presumably somebody is going to submit a git tree with the entire series
>> and you don't want me to pick up this piece, right?
>
> He better not expect us to take this stuff.

I'm going to do whatever each maintainer wants. :)

Sounds like you guys would like me to carry these in my tree, so I'll
add them to linux-next.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
