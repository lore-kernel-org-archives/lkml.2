Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab2J2UOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:14:22 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47207 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2J2UOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:14:18 -0400
Message-ID: <508EE395.9010709@ursulin.net>
Date: Mon, 29 Oct 2012 20:14:13 +0000
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Milan Broz <gmazyland@gmail.com>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org, okozina@redhat.com
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - regression from
 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com>
In-Reply-To: <508EDD6E.7030908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/12 19:47, Milan Broz wrote:
> On 10/29/2012 08:31 PM, Tvrtko Ursulin wrote:
>> Just tried 3.6.4 and it is still broken. Is there anything else I could
>> try to debug this?
>
> See response from response from Ondra on dmcrypt list - your kernel config
> is perhaps broken.

I don't think that reached me - perhaps I was not copied.

Weird yes, I mean no one can spot anything bad with my config...

> Please use fresh checkout, run make oldconfig and try again.
> (Many people use 3.6 already and there is no other report.)

... and I just used it today to configure a fresh 3.6.4 (plus -rt10 
patches) without a problem.

Unless RT patchset is the culprit. Hm.. that would be unexpected, but I 
guess it is worth a shot. I'll let you know what happens without -rt.

Thanks,

Tvrtko

