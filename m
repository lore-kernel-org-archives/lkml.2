Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0HUKFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 06:05:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35962 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0HUKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:05:47 -0400
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
In-Reply-To: <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	 <1281261789.2384.11.camel@localhost>
	 <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
	 <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 13:03:53 +0300
Message-ID: <1282385033.2358.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Aug 2010 10:05:31.0828 (UTC) FILETIME=[63B8FF40:01CB4118]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 13:07 -0700, Don Mullis wrote:
> On Sun, Aug 8, 2010 at 12:31 PM, Don Mullis <don.mullis@gmail.com> wrote:
> > Artem Bityutskiy <dedekind1@gmail.com> writes:
> >> Actually, your 'list_sort()' version does have a problem. I found out
> >> that it calls 'cmp(priv, a, b)' with 'a = b' sometimes, and in these
> >> cases 'a' and 'b' can point to something which is not a valid element of
> >> the original list. Probably a senitel or something like that.
> 
> Looks like if the original list is a POT in length, the first callback
> from line 73 will pass a==b both pointing to the original list_head.
> Would you be able to test this fix?

I'll turn your patch into a git am-able form and add CC to stable, and
send to you. You can then propagate it forward, or if you want, I can
send it to Andrew.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

