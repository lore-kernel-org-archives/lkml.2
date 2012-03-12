Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2CLBVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:21:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37470 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2CLBVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <4F5D4D1D.40004@gmail.com>
References: <4F5D4D1D.40004@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 12 Mar 2012 12:20:54 +1100
Message-ID: <CAGRGNgXjOvxr1e3PPfRZNKT8WVq9erTxNgiXPYPEmwdBWJVW_A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3]mac80211: improve PID rate control mechanism by
 avoiding rate oscillation problem
To: wei <yinwei168@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Again, a couple of comments

On Mon, Mar 12, 2012 at 12:10, wei <yinwei168@gmail.com> wrote:
> From Wei YIN <Wei.Yin@nicta.com.au>
> Improve PID rate control mechanism by avoiding rate oscillation problem
>
> Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
> ---
> kernel 3.3.0
> net/mac80211/rc80211_pid.h | 38 ++++++++++++++++++++++++++++++++++++++
> 1 file changed, 38 insertions(+), 0 deletions(-)

You shouldn't split this change up into separate files. When I said
"this should be in a separate patch" - I meant that the change I was
referring to was unrelated to what your patch was about - most of
these were minor cleanups or things like that. You should write
patches that do one thing and do it properly, and if you find any
places that could use work unrelated to that "one thing", those
changes should go in a separate patch.

Also, this patch looks like it adds all the data structures that the
first patch in this series would depend on - this should be part of
that patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
