Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2BRWwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 17:52:35 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2BRWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 17:52:34 -0500
References: <20120218185419.79376027@xenia.leun.net> (sfid-20120218_193621_030111_7D470738)
User-Agent: K-9 Mail for Android
In-Reply-To: <20120218185419.79376027@xenia.leun.net> (sfid-20120218_193621_030111_7D470738)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Cannot put ath9k interface to different namespace?
From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 18 Feb 2012 23:52:52 +0100
To: Michael Leun <lkml20120218@newton.leun.net>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
        senthilb@qca.qualcomm.com, linux-kernel@vger.kernel.org
Message-ID: <e7ff035b-562a-4222-80c4-eb501a3fcd6b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You have to put the entire wiphy into the netns with iw, not just one virtual interface. 

Michael Leun <lkml20120218@newton.leun.net> wrote:

>Hi,
>
>tried to put ath9k_htc interface to namespace, does not work:
>
>jill:/home/ml # ip link set netns 4001 dev wlan3
>RTNETLINK answers: Invalid argument
>
>Also does not work with ath9k, but does work with other wlan devices
>(tried zd1201, r8712u, thats what I've here at the moment).
>
>When trying, device was down.
>
>Is there some trick to do it or is there some support from driver for
>that missing?
>
>Any plans to fix that? Would that be big effort?
>
>Thanks.
>
>-- 
>MfG,
>
>Michael Leun
>
>--
>To unsubscribe from this list: send the line "unsubscribe
>linux-wireless" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my tablet. Please excuse my brevity.
