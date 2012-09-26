Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2IZJyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:54:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61485 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2IZJyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <1348649419-16494-3-git-send-email-minchan@kernel.org>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
	<1348649419-16494-3-git-send-email-minchan@kernel.org>
Date: Wed, 26 Sep 2012 12:54:06 +0300
X-Google-Sender-Auth: bH6AFkUfb-FUw8w6oXm1RaCv92c
Message-ID: <CAOJsxLHZ5Zq5_gsLXVkJcixAHkYm78t=K0AnfnLHU30dqSTesg@mail.gmail.com>
Subject: Re: [PATCH 2/3] zram: promote zram from staging
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:50 AM, Minchan Kim <minchan@kernel.org> wrote:
> It's time to promote zram from staging because zram is in staging
> for a long time and is improved by many contributors so code is
> very clean. Most important issue, zram's dependency with x86 is
> solved by making zsmalloc portable. In addition, many embedded
> product uses zram in real practive so I think there is no reason
> to prevent promotion now.
>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

FWIW,

Acked-by: Pekka Enberg <penberg@kernel.org>
