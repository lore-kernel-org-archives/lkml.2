Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2IJTGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:06:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60751 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2IJTGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:06:15 -0400
Date: Mon, 10 Sep 2012 15:06:10 -0400 (EDT)
Message-Id: <20120910.150610.41894888381057478.davem@davemloft.net>
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org, bjorn@mork.no, linux@sierrawireless.com,
        netdev@vger.kernel.org
Subject: Re: Endianess bug fix for sierra_net
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120907221402.GJ15650@csclub.uwaterloo.ca>
References: <20120907221402.GJ15650@csclub.uwaterloo.ca>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 7 Sep 2012 18:14:02 -0400

> I discovered I couldn't get sierra_net to work on a powerpc.  Turns out
> the firmware attribute check assumes the system is little endian and
> hence fails because the attributes is a 16 bit value.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

Applied and queued up for -stable, thanks.
