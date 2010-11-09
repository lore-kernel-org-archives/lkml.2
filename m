Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0KIB2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:28:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52963 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0KIB2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rufVdBVhNBUYMAZtN+K9mZpVWOooppEhpm7MedkCUY0T++l0pQq6Rvh9bzo0wvxYoa
         I5AID0XQH7I5bhGTaj6U1qlHoDrG6iNmsHtsKWi6zuVnta3vp9ZVuU6uzaT8q07uYakT
         QGTansElP1M31vpDjaqyfCCiEH8cry3VGxXUA=
MIME-Version: 1.0
In-Reply-To: <1289265320-7025-1-git-send-email-gthelen@google.com>
References: <1289265320-7025-1-git-send-email-gthelen@google.com>
Date: Tue, 9 Nov 2010 10:28:08 +0900
Message-ID: <AANLkTikDUkFgZ67tLeB080UhQByOc4yk4xmKTyEkJYq4@mail.gmail.com>
Subject: Re: [PATCH] memcg: avoid overflow in memcg_hierarchical_free_pages()
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 10:15 AM, Greg Thelen <gthelen@google.com> wrote:
> Use page counts rather than byte counts to avoid overflowing
> unsigned long local variables.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kind regards,
Minchan Kim
