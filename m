Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2AERNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:13:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60970 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab2AERNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:13:41 -0500
Date: Thu, 05 Jan 2012 12:12:25 -0500 (EST)
Message-Id: <20120105.121225.66084189564874875.davem@davemloft.net>
To: gurligebis@gentoo.org
Cc: romieu@fr.zoreil.com, shemminger@vyatta.com, bhutchings@solarflare.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on
 low-end broads.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACPM=kWL+Z6PH268qg=i0Nafrouq4O25+uFf8WLcE08azqpqpA@mail.gmail.com>
References: <20120103223243.GB8563@electric-eye.fr.zoreil.com>
	<CACPM=kUhBydaVDQaxs7BaB_ZkFRa2p6cVme-77Gbsk+QDk=MFA@mail.gmail.com>
	<CACPM=kWL+Z6PH268qg=i0Nafrouq4O25+uFf8WLcE08azqpqpA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 05 Jan 2012 09:12:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Date: Thu, 5 Jan 2012 13:01:41 +0100

> Sorry for repeating myself David, but would it be possible to get this
> into net-next for 3.4 inclusion?

Francois will formally submit it to me when he feels it is
appropriate, please be patient.
