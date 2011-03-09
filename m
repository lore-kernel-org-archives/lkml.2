Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1CIWJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:09:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60870
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790Ab1CIWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:09:14 -0500
Date: Wed, 09 Mar 2011 14:09:51 -0800 (PST)
Message-Id: <20110309.140951.232741403.davem@davemloft.net>
To: sledz@dresearch.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        m.schuknecht@dresearch.de
Subject: Re: [PATCH v3] tcp: ioctl type SIOCOUTQNSD returns amount of data
 not sent
From: David Miller <davem@davemloft.net>
In-Reply-To: <1299441595-18455-1-git-send-email-sledz@dresearch.de>
References: <20110304123950.2c91ebd9@lxorguk.ukuu.org.uk>
	<1299441595-18455-1-git-send-email-sledz@dresearch.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Sledz <sledz@dresearch.de>
Date: Sun,  6 Mar 2011 20:59:55 +0100

> From: Mario Schuknecht <m.schuknecht@dresearch.de>
> 
> In contrast to SIOCOUTQ which returns the amount of data sent
> but not yet acknowledged plus data not yet sent this patch only
> returns the data not sent.
> 
> For various methods of live streaming bitrate control it may
> be helpful to know how much data are in the tcp outqueue are
> not sent yet.
> 
> Signed-off-by: Mario Schuknecht <m.schuknecht@dresearch.de>
> Signed-off-by: Steffen Sledz <sledz@dresearch.de>

Applied, thanks.
