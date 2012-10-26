Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966103Ab2JZTJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:09:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50195 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966Ab2JZTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:09:16 -0400
Date: Fri, 26 Oct 2012 15:09:14 -0400 (EDT)
Message-Id: <20121026.150914.698922406187249983.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-10-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121026152112.GB16104@tuxdriver.com>
References: <20121026152112.GB16104@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 26 Oct 2012 11:21:13 -0400

> This is a batch of fixes intended for the 3.7 stream.
> 
> Bing Zhao brings two mwifiex fixes, both continuing to fix some scanning
> failure cases.
> 
> Christian Lamparter provides an rtlwifi fix to properly propogate an
> error code.
> 
> Felix Fietkau reverts a previous fix that was improperly reducing Tx
> power for some devices.  This one looks big, but it is mostly just
> changes to a table of initialization values.
> 
> Larry Finger provides a b43 version of an earlier b43legacy fix to
> avoid and oops when removing the modules after failing to load firmware.
> 
> Mohammed Shafi Shajakhan provides a new device ID for ath9k_htc.
> 
> Stanislaw Gruszka gives us an rt2x00 fix to avoide a WARNING during
> resume, as described in kernel.org bug 48041.
> 
> Yuanhan Liu fixes a potential NULL dereference in brcmfmac.

Pulled, thanks John.
