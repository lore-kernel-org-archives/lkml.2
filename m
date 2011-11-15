Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1KOIqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:46:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65185 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1KOIqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:46:49 -0500
MIME-Version: 1.0
In-Reply-To: <c897fa89d5ea94c6624e8cdab9787aa83526f994.1321343212.git.wpan@redhat.com>
References: <c897fa89d5ea94c6624e8cdab9787aa83526f994.1321343212.git.wpan@redhat.com>
Date: Tue, 15 Nov 2011 16:46:48 +0800
Message-ID: <CAM_iQpXCtH1cSJFsWVGrdreyhBgAjujLygktQGrK7iP-zyhN5g@mail.gmail.com>
Subject: Re: [PATCH] vlan:return error when real dev is enslaved
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Weiping Pan <wpan@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        "open list:VLAN (802.1Q)" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 4:36 PM, Weiping Pan <wpan@redhat.com> wrote:
> +       if (real_dev->flags & IFF_SLAVE) {
> +               pr_info("Error, %s was already enslaved\n", name);
> +               return -EOPNOTSUPP;
> +       }

Use pr_err() then.
