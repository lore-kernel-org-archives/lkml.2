Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1G3QlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 12:41:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64249 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1G3QlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 12:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
References: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
Date: Sat, 30 Jul 2011 18:41:12 +0200
Message-ID: <CAFLxGvyGQ3Ao4BLHzuZOraOTf=PMFG67OgjTR3J8_-dFp_tf8w@mail.gmail.com>
Subject: Re: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Zoltan Devai <zdevai@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-am33-list@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net, chris@zankel.net,
        cmetcalf@tilera.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 6:14 PM, Zoltan Devai <zdevai@gmail.com> wrote:
> Commit 592913ecb87a9e06f98ddb55b298f1a66bf94c6b has killed off any
> use of this config option long ago.
>
> Signed-off-by: Zoltan Devai <zdevai@gmail.com>

For arch/um/:
Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
