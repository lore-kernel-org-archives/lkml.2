Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2FYPdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:33:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34082 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2FYPdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAD2nsn08gkYJnyYfqyZT8VX-bFPgDVZPgVSHE_QBEuXj5aEWMw@mail.gmail.com>
References: <1340637550-12669-1-git-send-email-aletes.xgr@gmail.com>
	<CAD2nsn08gkYJnyYfqyZT8VX-bFPgDVZPgVSHE_QBEuXj5aEWMw@mail.gmail.com>
Date: Mon, 25 Jun 2012 12:33:51 -0300
Message-ID: <CAAAP30EaW67e_w0k0W5qasaFfccfn0pDtqdHQB+-hesEbJwOLQ@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix build warning
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 12:31 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> Hi,
>
> On Mon, Jun 25, 2012 at 8:49 PM, Alexandre Pereira da Silva
> <aletes.xgr@gmail.com> wrote:
>> Fix:
>> net/mac80211/mlme.c: In function 'ieee80211_prep_connection':
>> net/mac80211/mlme.c:3035:19: warning: 'sta' may be used uninitialized in
>> this function
>>
>> Initialize sta to NULL
>
> i think already fixed by and there in wireless-testing
> http://www.spinics.net/lists/linux-wireless/msg92385.html

Ok, thanks for pointing that out.
