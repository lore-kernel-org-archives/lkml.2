Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2FYPbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:31:31 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40309 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2FYPb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <1340637550-12669-1-git-send-email-aletes.xgr@gmail.com>
References: <1340637550-12669-1-git-send-email-aletes.xgr@gmail.com>
Date: Mon, 25 Jun 2012 21:01:28 +0530
Message-ID: <CAD2nsn08gkYJnyYfqyZT8VX-bFPgDVZPgVSHE_QBEuXj5aEWMw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix build warning
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 25, 2012 at 8:49 PM, Alexandre Pereira da Silva
<aletes.xgr@gmail.com> wrote:
> Fix:
> net/mac80211/mlme.c: In function 'ieee80211_prep_connection':
> net/mac80211/mlme.c:3035:19: warning: 'sta' may be used uninitialized in
> this function
>
> Initialize sta to NULL

i think already fixed by and there in wireless-testing
http://www.spinics.net/lists/linux-wireless/msg92385.html

>
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
>  net/mac80211/mlme.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 91d84cc..cfe6b43 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3032,7 +3032,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
>        struct ieee80211_local *local = sdata->local;
>        struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>        struct ieee80211_bss *bss = (void *)cbss->priv;
> -       struct sta_info *sta;
> +       struct sta_info *sta = NULL;
>        bool have_sta = false;
>        int err;
>        int ht_cfreq;
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
