Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1CCTx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:53:29 -0500
Received: from smtpq2.gn.mail.iss.as9143.net ([212.54.34.165]:46536 "EHLO
	smtpq2.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224Ab1CCTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:53:28 -0500
Subject: Re: Mass udp flow reboot linux with RealTek RTL-8169 Gigabit
From: Hans Nieser <hnsr@xs4all.nl>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1298641542.18103.48.camel@krikkit>
References: <1298396007.23906.27.camel@krikkit>
	 <20110223095538.GA12662@electric-eye.fr.zoreil.com>
	 <1298463704.31256.29.camel@krikkit>  <1298485893.31256.40.camel@krikkit>
	 <1298641542.18103.48.camel@krikkit>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 20:53:25 +0100
Message-ID: <1299182005.28968.9.camel@krikkit>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1PvEaT-0003oj-O9
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=-4.918, vereist 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, PROLO_TRUST_RDNS -3.00, RDNS_DYNAMIC 0.98)
X-ZiggoSMTP-MailScanner-From: hnsr@xs4all.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 14:45 +0100, Hans Nieser wrote:
...
> I've also attempted to bisect the issue I have been having with slow
> transfer speed (I don't know if its related to the hang, but I figure if
> the hang ever gets fixed, this will have to be fixed as well to make
> r8169 usable for me)
...

Just wanted to let you know that after installing a new Intel gbit NIC I
ordered, I sadly still get poor performance, so this is definitely a
separate issue from the r8169 lock up. (lock ups are gone now)

I've given up on getting r8169 working at this point but if you have any
patches you need tested or need more info in the future please do let me
know

