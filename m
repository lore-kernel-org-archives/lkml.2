Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1BAX35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:29:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43236 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1BAX34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=VbXtrxQ6Y2tnATgVNvZEU6PNS/6jU04GIpgsvXef8YZJV68Rb0vgnhl0cZAjRuHkpw
         xoPgSybXe/I2X14VqrXlJsTBJJcAgK4pOUVo9LkkXB27aR5Vo4oP+JGOZXY51BXC9Hl8
         N9N5gnZjxR1YBNFQ6dz2Ycgrfj0Lp3Da1J9UQ=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Feb 2011 15:29:35 -0800
Message-ID: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
Subject: Support for Android for mac80211 / cfg80211 802.11 drivers
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Xin Jin <Xin.Jin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get poked every now and then for Android support for mac80211 or
cfg80211 drivers. Since the questions is quite common I figured It'd
be good to document what needs to get done for this. Android folks,
you listening?

http://wireless.kernel.org/en/developers/Documentation/Android

If you already have worked on this or are going to please feel free to
update the wiki so no one else re-invents the wheel.

Thanks,

 Luis
