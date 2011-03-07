Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1CGJXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:23:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59770 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1CGJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:23:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=T50bEm1FHQ8pqU1s4jHhhrZAwoxJi6HLNPe1AOkhOQsjtrTLi6C9VatajXCfNAFOMj
         Y47Bsw//aSqny0n/KIeZtITsnAxydOu1cuU0kmIKSJGwAVnTm5c/YaHPiJq6laYmLsyQ
         svExzW8lInI+zRbgx4Kptd0URiqm1+Yabl1k4=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-16-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-16-git-send-email-cesarb@cesarb.net>
Date: Mon, 7 Mar 2011 11:23:00 +0200
X-Google-Sender-Auth: W9krARwFEZmV8PlO9yqHhOund8g
Message-ID: <AANLkTinZtF2Gw4Ji4ZkTjgkLA45sQMH23HGPw7pKJKrD@mail.gmail.com>
Subject: Re: [PATCHv2 15/24] sys_swapon: move setting of swapfilepages near use
From: Pekka Enberg <penberg@kernel.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 6:42 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> There is no reason I can see to read inode->i_size long before it is
> needed. Move its read to just before it is needed, to reduce the
> variable lifetime.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
