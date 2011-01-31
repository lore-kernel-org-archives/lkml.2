Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1AaWwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:52:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45745 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab1AaWwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z/mfsIfpVH0zz9bx6lVw8rBYXy5/1lA7jTqcLGVzt1Bd2YGlcS2kgoMuMgFq1epcZi
         1Fx8t8vFWW3Elr3pWh+KKtbW2EA5NkE0aDZvo/UYhykB0eR7aRGkUNfHEUXTymDmoZYB
         xYAFoDESdBM+gN36uVuBRYGrJ2Q7ee4q/2jiQ=
MIME-Version: 1.0
In-Reply-To: <1296482635-13421-4-git-send-email-hannes@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-4-git-send-email-hannes@cmpxchg.org>
Date: Tue, 1 Feb 2011 07:52:14 +0900
Message-ID: <AANLkTin5qvaHy2=6gE1W_MEA88GXsCvtxBS2kjxG2x23@mail.gmail.com>
Subject: Re: [patch 3/3] memcg: never OOM when charging huge pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:03 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Huge page coverage should obviously have less priority than the
> continued execution of a process.
>
> Never kill a process when charging it a huge page fails.  Instead,
> give up after the first failed reclaim attempt and fall back to
> regular pages.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
