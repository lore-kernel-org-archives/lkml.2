Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2BHW3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:29:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61931 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2BHW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:29:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120207122317.GA2289@Pilar.site>
References: <20120206002907.GA1899@Pilar.site>
	<20120206175702.3a41ffc4@mj>
	<20120207122317.GA2289@Pilar.site>
Date: Wed, 8 Feb 2012 16:29:40 -0600
Message-ID: <CAMY-HrAq7FEmMeELrX-hDU03K54CO0s=esxFNgdCZHUPadn4mA@mail.gmail.com>
Subject: Re: [ath9k-devel] [3.3-rc2+] Thousands of ath9k warnings on dmesg
 before laptop froze
From: Calvin Owens <jcalvinowens@gmail.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been having this issue on x86_64 with 3.3-rc2+ as well. I got a
panic a couple days ago, but I haven't been able to reproduce it.

I can, however, reproduce the WARN_ON()'s on my laptop by pinging an
external server with a high frequency (.1s works well) while walking
in circles around the 2nd floor of a nearby library. (It's kind of
hilarious, but that's the only way I seem to be able to get it).

I can confirm that Pavel's patch resolves the problem. Feel free to add:
Tested-by: Calvin Owens <jcalvinowens@gmail.com>

Thanks,
Calvin
