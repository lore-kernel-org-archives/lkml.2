Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1C0JRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 05:17:46 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:54259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1C0JRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 05:17:44 -0400
Subject: Re: [PATCH] mac80211: fix possible NULL pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1301162331-5236-1-git-send-email-mk@lab.zgora.pl>
References: <1301162331-5236-1-git-send-email-mk@lab.zgora.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 11:17:36 +0200
Message-ID: <1301217456.3826.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 18:58 +0100, Mariusz Kozlowski wrote:
> This patch moves 'key' dereference after BUG_ON(!key) so that when key is NULL
> we will see proper trace instead of oops.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I guess, not that it matters much since it's extremely unlikely somebody
will attemt to misuse this function :-)

johannes


