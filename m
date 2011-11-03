Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535Ab1KCTZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:25:44 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58734 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934458Ab1KCTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:25:43 -0400
Message-ID: <4EB2EA93.2050206@parallels.com>
Date: Thu, 3 Nov 2011 17:25:07 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag> <4EB2C4A5.6000406@parallels.com> <20111103165903.GA4755@Debian-60-squeeze-64-minimal> <20111103182101.5037c1e5@lxorguk.ukuu.org.uk> <20111103185108.GA5153@Debian-60-squeeze-64-minimal> <20111103190330.02590426@lxorguk.ukuu.org.uk> <20111103192039.GA5300@Debian-60-squeeze-64-minimal>
In-Reply-To: <20111103192039.GA5300@Debian-60-squeeze-64-minimal>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 05:20 PM, Max Kellermann wrote:
> On 2011/11/03 20:03, Alan Cox<alan@lxorguk.ukuu.org.uk>  wrote:
>> Sure - I'm just not seeing that a whole separate cgroup for it is
>> appropriate or a good plan. Anyone doing real resource management needs
>> the rest of the stuff anyway.
>
> Right.  When I saw Frederic's controller today, my first thought was
> that one could move the fork limit code over into that controller.  If
> we reach a consensus that this would be a good idea, and would have
> chances to get merged, I could probably take some time to refactor my
> code.
>
> Max
I'd advise you to take a step back and think if this is really needed. 
As Alan pointed out, the really expensive resource here is already being
constrained by Frederic's controller.

But ultimately, you're the only one that knows about your real 
requirements.
