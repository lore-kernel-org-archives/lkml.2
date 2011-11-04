Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab1KDWah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:30:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47927 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1KDWag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:30:36 -0400
MIME-Version: 1.0
In-Reply-To: <20111104191343.GB13505@tuxdriver.com>
References: <20111104191343.GB13505@tuxdriver.com>
Date: Fri, 4 Nov 2011 23:30:34 +0100
Message-ID: <CACna6ryikPeppgrUvdhCYGjbi7hBOOcaX6YAz6CgFwd6dbsmfA@mail.gmail.com>
Subject: Re: pull request: wireless 2011-11-04
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/4 John W. Linville <linville@tuxdriver.com>:
> commit 22097fd297c85ec6c2e700d506f231f7cae442e1
>
> Dave,
>
> Here is the first batch of wireless fixes intended for 3.2 -- hooray!

John, could you take a look at 2 patches?
[PATCH 3.2 REQ V2] b43: HT-PHY: report signal to mac80211
[PATCH V2 3.2] b43: fill ctl1 word on all newer PHYs, fix PHY errors
I don't think there were commited for 3.2 or rejected by you.

Were there any problems with that 2 patches?

-- 
Rafał
