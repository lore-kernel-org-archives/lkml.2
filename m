Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2HLUlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 16:41:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37098 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2HLUlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 16:41:19 -0400
Date: Sun, 12 Aug 2012 13:41:18 -0700 (PDT)
Message-Id: <20120812.134118.90820419749031873.davem@davemloft.net>
To: mst@redhat.com
Cc: yefremov.denis@gmail.com, jasowang@redhat.com, ebiederm@xmission.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH v2] macvtap: rcu_dereference outside read-lock section
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120812084929.GB4430@redhat.com>
References: <20120811.181642.1587792778007257202.davem@davemloft.net>
	<1344752791-21140-1-git-send-email-yefremov.denis@gmail.com>
	<20120812084929.GB4430@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 12 Aug 2012 11:49:29 +0300

> On Sun, Aug 12, 2012 at 10:26:31AM +0400, Denis Efremov wrote:
>> rcu_dereference occurs in update section. Replacement by
>> rcu_dereference_protected in order to prevent lockdep
>> complaint.
>> 
>> Found by Linux Driver Verification project (linuxtesting.org)
>> 
>> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
...
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks everyone.
