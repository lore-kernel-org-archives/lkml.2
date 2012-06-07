Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2FGMh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:37:58 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63318 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2FGMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gKLrd4JUf5P=zkj4x_yYc-kk2kjA-0To9e7iRNbZcCpLxA@mail.gmail.com>
References: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
	<CA+i8gKKQyGBc-BNBJ72S6rq7aiFqS=onqWQyeY4P+VVvFCeXJw@mail.gmail.com>
	<CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
	<CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
	<CAJd=RBBxnD7JirPpy-jTgE9kpnZXN6gkTMsgcG8=goZxgQfTaQ@mail.gmail.com>
	<CA+i8gKLrd4JUf5P=zkj4x_yYc-kk2kjA-0To9e7iRNbZcCpLxA@mail.gmail.com>
Date: Thu, 7 Jun 2012 20:37:55 +0800
Message-ID: <CAJd=RBCa_JfHO-=HiGqz_13CaHj5KGE5-EYAYT3jd+FPofqybw@mail.gmail.com>
Subject: Re: [patch] BFS 420: a tiny step forward
From: Hillf Danton <dhillf@gmail.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Manuel Krause <manuelkrause@t-online.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel

On Wed, Jun 6, 2012 at 11:51 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> Unfortunately, the issue is still there.
>
Hang at same place?

> I also tried with all of your today's patches, still the same.
>
According to messages from Manuel, I know 421 works with the revert-ttwu patch
applied on Tualatin(non SMP), and no other patches needed. If you include the
recent 6 patches, please exclude them all just for narrowdown of hang causes,
as they are for 422.

Are you compiling with SMP enabled? Other info of hang available?

Thanks and Regards
Hillf
