Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1C0JSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 05:18:31 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:54262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1C0JSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 05:18:30 -0400
Subject: Re: [PATCH] cfg80211:: fix possible NULL pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1301164015-7978-1-git-send-email-mk@lab.zgora.pl>
References: <1301164015-7978-1-git-send-email-mk@lab.zgora.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 11:18:27 +0200
Message-ID: <1301217507.3826.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 19:26 +0100, Mariusz Kozlowski wrote:
> In cfg80211_inform_bss_frame() wiphy is first dereferenced on privsz
> initialisation and then it is checked for NULL. This patch fixes that.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

johannes


