Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1ITRAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:00:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1ITRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:00:07 -0400
Date: Tue, 20 Sep 2011 12:59:52 -0400 (EDT)
Message-Id: <20110920.125952.2106297850071490228.davem@davemloft.net>
To: bottomofstack@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: bridge and ipv6 question.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+UXGK2rDrOvmpeugn2=HjSY6y8=D+L-rvkY8eLX7LvTQnzTVw@mail.gmail.com>
References: <CA+UXGK2rDrOvmpeugn2=HjSY6y8=D+L-rvkY8eLX7LvTQnzTVw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Sep 2011 10:00:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Xiong <bottomofstack@gmail.com>
Date: Tue, 20 Sep 2011 15:44:49 +0800

> Hi all:
> Sorry for disturb! when adding a interface to bridge, maybe the bridge
> mac address will be changed. the bridge code don't invoke
> call_netdevice_notifiers to notify ipv6 code to refresh local link
> address. I don't know why. Thanks for your help!

Better to ask networking questions on the networking development list,
netdev@vger.kernel.org, rather than here.
