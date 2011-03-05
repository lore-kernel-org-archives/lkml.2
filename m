Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1CERU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:20:28 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:48016 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1CERU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:20:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=V07/wCb3LyKnoFeJca2TI/VVViNh1cUxFXByNvwwx2ORxU5+7LiDBzOWjr6su4Kkxs
         PeIlOzkim1/J8cJgzUTzphzaRJE5f9V8pd7HVtwmclmH8Wgz52RMnScZPxCYUtf9Pqha
         ldwRezi4uamBBRc+5/Q6YIyGyW/OjvsAwk83E=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-25-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-25-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:20:25 +0200
X-Google-Sender-Auth: yHMmwdwarILBMuYIIkrlSpOgCvw
Message-ID: <AANLkTinEsm6yGcaTMZOVGShSvCVKKMQnHBQec6w1_MtS@mail.gmail.com>
Subject: Re: [PATCHv2 24/24] sys_swapon: separate final enabling of the swapfile
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
> The block in sys_swapon which does the final adjustments to the
> swap_info_struct and to swap_list is the same as the block which
> re-inserts it again at sys_swapoff on failure of try_to_unuse(). Move
> this code to a separate function, and use it both in sys_swapon and
> sys_swapoff.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
