Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1CERHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:07:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52755 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1CERHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sUsJIpekBII15nbZ4ReTzCQLPVTCaGYOlwuSigVS3LFTeYoNfVzDjJfjFxYq4yWJ79
         EezbZ+7OS35d/aJF3Ida13AxT+6MElIIbwYT8qUBW/w5kQOhf5gwJfUjdzfc5QVExhlN
         to2pGGsVd2FeDJPOwYLdXqlX7OzWyMpd4C41c=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-5-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-5-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:07:48 +0200
X-Google-Sender-Auth: TGcBFQjTaYFy_QPxHQUFSzb8Wzg
Message-ID: <AANLkTi=aoWZYvESDf-pOzd8Yj+5vJtdFy62LfRZ87-TL@mail.gmail.com>
Subject: Re: [PATCHv2 04/24] sys_swapon: separate swap_info allocation
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
> Move the swap_info allocation to its own function. Only code movement,
> no functional changes.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
