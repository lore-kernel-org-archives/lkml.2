Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2A3JBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:01:39 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42625 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab2A3JBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:01:38 -0500
MIME-Version: 1.0
In-Reply-To: <1327269381-20748-2-git-send-email-richard@nod.at>
References: <1327269381-20748-1-git-send-email-richard@nod.at>
	<1327269381-20748-2-git-send-email-richard@nod.at>
Date: Mon, 30 Jan 2012 10:01:37 +0100
Message-ID: <CAFLxGvzLvdyyaBvh7LCM2+tTmKobK6n8jTRoH8NXd=MVmN4ocA@mail.gmail.com>
Subject: Re: [PATCH 1/6] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012 at 10:56 PM, Richard Weinberger <richard@nod.at> wrote:
> ipt_LOG and ip6_LOG have a lot of common code, merge them
> to reduce duplicate code.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

No comments?

-- 
Thanks,
//richard
