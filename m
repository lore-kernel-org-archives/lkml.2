Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2CHG7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:59:12 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58222 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2CHG7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:59:10 -0500
Date: Wed, 07 Mar 2012 22:57:52 -0800 (PST)
Message-Id: <20120307.225752.1535997011608677011.davem@davemloft.net>
To: padovan@profusion.mobi
Cc: gustavo@padovan.org, johan.hedberg@gmail.com, marcel@holtmann.org,
        linville@tuxdriver.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-03-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120308054431.GE3998@joana>
References: <20120308054431.GE3998@joana>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Mar 2012 22:57:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gustavo Padovan <padovan@profusion.mobi>
Date: Thu, 8 Mar 2012 02:44:31 -0300

> Hi Dave,
> 
> Here goes another try to merge the bluetooth-next changes. I looked to the
> whole diff of the last pull request and fixed all the style issues you
> reported in last pull request attempt. The diff is very big, so I may have
> missed some places, but we are, from your coding style point of view, in a
> much better state than before.
> 
> Please take a look on it and pull if you find the code suitable, otherwise
> tell me what's wrong and how we should fix it since your coding style rules
> are not written in CodingStyle.
> 
> About the patches:
>  - almost half of the patches is in the new Bluetooth Management interface, it
>  finally reached a stable state regarding its API and we now enable it by
>  default.
>  - lots of Bluetooth LE patches. This implementation is still unstable but
>    disabled by default.
>  - some L2CAP layer refactoring to make our core code more generic and
>    reusable.
>  - New HCI monitor interface to monitor Bluetooth flow.
>  - Lot of fixes and clean ups all over the Bluetooth subsystem.

Pulled, thanks a lot.
