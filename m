Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3AEKFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 05:05:07 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:43294 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3AEKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 05:05:00 -0500
Date: Sat, 5 Jan 2013 10:37:18 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?utf-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [3.8-rc] regression: NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
Message-ID: <20130105093718.GA938@electric-eye.fr.zoreil.com>
References: <CADDKRnBqxSwC7HUP_aN1QELrv2+7jnncXj7EP0Pqv8E8FFTpPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDKRnBqxSwC7HUP_aN1QELrv2+7jnncXj7EP0Pqv8E8FFTpPw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg Otte <jrg.otte@gmail.com> :
[...]
> It's a regression, it never happend before 3.8-rc.

Please check that 'dmesg | grep XID' exhibits a 8168evl.

I'll showe and dig it. It's epidemic.

-- 
Ueimor
