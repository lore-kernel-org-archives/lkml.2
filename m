Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1CERSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:18:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1CERSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MAs0mOxS9nofSsudHKIMHv2zIsgf4qX8U6YSftfbxH9ffvgFSht+AJtMNtlSI5PmVG
         80OToeKueH+AmIm21KBefXBo8wUJtx/T6gz44lPNyDywU3GzibjLYKnr/sricJMQl+Hf
         f0WFr7iGyCiDVJoZ6J1QiT5bZDS3Zz3hog3Mo=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-22-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-22-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:18:13 +0200
X-Google-Sender-Auth: _474qEL0ZFrlPKmFaRJs4Gtjzmw
Message-ID: <AANLkTimm7YUusvVkYVKn-wqn-3_YeLTzMYJif-Amyb3W@mail.gmail.com>
Subject: Re: [PATCHv2 21/24] sys_swapon: remove nr_good_pages variable
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
> It still exists within setup_swap_map_and_extents(), but after it
> nr_good_pages == p->pages.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
