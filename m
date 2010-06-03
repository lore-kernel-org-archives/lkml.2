Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0FCTak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:30:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45366
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab0FCTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:30:38 -0400
Date: Thu, 03 Jun 2010 12:30:48 -0700 (PDT)
Message-Id: <20100603.123048.226791381.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-06-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100603173843.GB14597@tuxdriver.com>
References: <20100603173843.GB14597@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 3 Jun 2010 13:38:43 -0400

> This is a handful of fixes intended for 2.6.35.  The ath5k patch fixes a
> problem reported by multiple people as "Commit 6b5d11 breaks association
> with WPA enabled APs".  The ones from Johannes fix a locking problem and
> and a problem caused by reading the wrong data location.
> 
> Please let me know if there are problems!

Pulled, thanks John!
