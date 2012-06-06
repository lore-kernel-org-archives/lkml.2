Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2FFPvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:51:48 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43436 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2FFPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBxnD7JirPpy-jTgE9kpnZXN6gkTMsgcG8=goZxgQfTaQ@mail.gmail.com>
References: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
	<CA+i8gKKQyGBc-BNBJ72S6rq7aiFqS=onqWQyeY4P+VVvFCeXJw@mail.gmail.com>
	<CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
	<CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
	<CAJd=RBBxnD7JirPpy-jTgE9kpnZXN6gkTMsgcG8=goZxgQfTaQ@mail.gmail.com>
Date: Wed, 6 Jun 2012 22:51:46 +0700
Message-ID: <CA+i8gKLrd4JUf5P=zkj4x_yYc-kk2kjA-0To9e7iRNbZcCpLxA@mail.gmail.com>
Subject: Re: [patch] BFS 420: a tiny step forward
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Manuel Krause <manuelkrause@t-online.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

On Sat, Jun 2, 2012 at 4:50 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Hi Emmanuel and Manuel
>
> On Thu, May 31, 2012 at 9:16 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>
>> it builds fine now but it won't boot. Some crappy
>> mobile phone picture here:
>> http://ompldr.org/vZTE1eQ/IMG_20120531_200543.jpg
>>
> The ttwu was messed up by Hillf, lets revert it.

Unfortunately, the issue is still there. I also tried with all of your
today's patches, still the same.

Thanks
-- Emmanuel
