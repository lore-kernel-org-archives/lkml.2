Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1HBAqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:46:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54716 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1HBAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:46:26 -0400
Date: Mon, 01 Aug 2011 17:44:55 -0700 (PDT)
Message-Id: <20110801.174455.497874654640729014.davem@davemloft.net>
To: florian@mickler.org
Cc: stse+lkml@fsing.rootsland.net, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: IP forwarding regression since 3.0-rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110801212903.3c69275b@schatten.dmk.lab>
References: <20110729T091342.GA.06bf4.stse@fsing.rootsland.net>
	<20110729.003620.1377780539620085743.davem@davemloft.net>
	<20110801212903.3c69275b@schatten.dmk.lab>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 01 Aug 2011 17:44:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Mickler <florian@mickler.org>
Date: Mon, 1 Aug 2011 21:29:03 +0200

> You probably have already an opinion on this, but maybe it didn't
> occur to anybody yet... so I'm throwing it out there... (and quickly
> taking shelter :) ) What about directing the bugzilla mails for
> networking bugs to netdev@vger.kernel.org?

If they haven't been vetted by a human first, I'll just flat out
delete every single posting that thing generates.

That's the whole point of the current system, a human reviews the
report to see if it's garbage or even worthwhile before posting
it here.
