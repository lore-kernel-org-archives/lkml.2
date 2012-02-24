Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2BXT6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:58:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39431 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2BXT6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:58:34 -0500
Date: Fri, 24 Feb 2012 14:57:37 -0500 (EST)
Message-Id: <20120224.145737.662334352795127267.davem@davemloft.net>
To: w.landgraf@ru.ru
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org
Subject: Re: [Bug #42669] 3.3-rc1: compiling problems nvme , l2cap_sock ,
 mc13892-regulator , and snd-pcsp don't work
From: David Miller <davem@davemloft.net>
In-Reply-To: <web-701709481@zbackend1.aha.ru>
References: <qCQH7HfZS8E.A.FVG.M9rRPB@chimera>
	<20120223.181904.501214130038312055.davem@davemloft.net>
	<web-701709481@zbackend1.aha.ru>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 11:57:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "werner" <w.landgraf@ru.ru>
Date: Fri, 24 Feb 2012 06:48:58 -0400

> But why then the error is still in the source code, at least until the
> last 3.3-rc4 ???  I also compiled the code, removing always inline
> from the line as in the patch, then it works.

Because the fix is in the networking maintainer's tree and will shortly
be sent to Linus for inclusion.

> This things happens, because people, after changes, nor compile them
> subroutines ...  :( Much less, test them ...

You need to relax.

The compile error only occurs with more recently compiler versions, so
it worked for the majority of people and in fact it compiles just fine
for me without the fix too.
