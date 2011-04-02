Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1DBASJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:18:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44041
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261Ab1DBASH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:18:07 -0400
Date: Fri, 01 Apr 2011 17:17:29 -0700 (PDT)
Message-Id: <20110401.171729.112600173.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-04-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110401141224.GA3253@tuxdriver.com>
References: <20110401141224.GA3253@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 1 Apr 2011 10:12:26 -0400

> On the Bluetooth front, we have a WARNING fix related to debugobjects, a
> fix for L2CAP channel hang, a fix for an unlock without a lock, a fix to
> check for LE connections before discarding data, a fix for
> synchronization after HCI_RESET, an accounting fix for unacked frames,
> and a device ID addition.
> 
> For wireless LANs, an iwlegacy fix to prevent a possible crash during a
> firmware restart, a carl9170 fix to generate BlockAckReq if the
> transmission of an AMPDU subframe fails (i.e. an interop fix), an
> iwl3945 change to disable hw scan by default due to a number of related
> problems, a related debug message change to avoid some confusion, a fix
> for aggregation frame reordering, a cfg80211 fix to avoid
> double-unlinking a BSS entry, a trio of NULL pointer deref fixes, an
> ath9k fix to avoid a bus error during restart, a minstrel_ht fix to
> avoid a crash when no supported MCS rates are found, and some new device
> IDs for rt2x00.
> 
> Please let me know if there are problems!

Looks good, pulled, thanks John.
