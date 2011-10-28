Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1J1DB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:01:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45012 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1J1DB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:01:28 -0400
Date: Thu, 27 Oct 2011 23:01:20 -0400 (EDT)
Message-Id: <20111027.230120.1348321590012576474.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: marcos.mage@gmail.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove quotes of maintaners's names
From: David Miller <davem@davemloft.net>
In-Reply-To: <610B86C6-622E-4EFE-89DF-BF09BDB4D765@intel.com>
References: <1319739381-5244-1-git-send-email-marcos.mage@gmail.com>
	<610B86C6-622E-4EFE-89DF-BF09BDB4D765@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 27 Oct 2011 20:01:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Date: Thu, 27 Oct 2011 14:35:54 -0700

> The reason these names are in quotes is because they need to be
> wrapped in quotes when used in a git patch (I.e. CC: "David
> S. Miller" <davem@davemloft.net>) because of the . in the friendly
> name.

That's correct, if a character such as "." appears in an email
header field it must be surrounded by double quotes, as per
SMTP rules.

VGER rejects any email where this rule is not followed properly.
