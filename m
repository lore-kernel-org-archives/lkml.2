Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0GMJWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:22:18 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4694 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab0GMJWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:22:16 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o6D9LuKl028414
Subject: Re: [PATCH] Staging: vt6656: Change the define FALSE and TRUE to
 the lower case variant.
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1278969997-24254-1-git-send-email-roel.vannyen@gmail.com>
References: <1278969997-24254-1-git-send-email-roel.vannyen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 11:21:55 +0200
Message-ID: <1279012915.28403.235.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2010-07-12 at 23:26 +0200, Roel Van Nyen wrote:
[...]
> @@ -178,7 +178,7 @@ vMgrDecodeBeacon(
>              break;
>          case WLAN_EID_RSN_WPA:
>              if (pFrame->pRSNWPA == NULL) {
> -                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
> +                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
>                      pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
>              }
>              break;

Am I the only one who thinks that this should better be
----  snip  ----
@@ -178,7 +178,7 @@ vMgrDecodeBeacon(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem))
                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
----  snip  ----
- if only for readability and understandability?

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

