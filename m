Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2FJOdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:33:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22400 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab2FJOdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:33:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 188.77.103.10
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+4k0EmxecK/2yvjyL9Izyr
Date: Sun, 10 Jun 2012 16:27:25 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: More reiserfs hangs, easy to reproduce (Sheevaplug)
Message-ID: <20120610142724.GA2039@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had since the latest 2.6 kernels lockups in a sheevaplug computer (without
swap), when it reached OOMK conditions. The machine was in such a deadlock that
it only answered to sysrq request through the serial console. Almost every OOMK
caused this, so once you reproduce an OOMK, I think it will almost sure hang the
system. The lock looks related to swapping in read-only pages of programs.

As I recently experienced reiserfs lockups in a desktop pc
(http://www.spinics.net/lists/reiserfs-devel/msg03157.html), I wondered if those
OOMK lockups could happen due to the reiserfs of /.  So I moved / to ext4, and
all locks disappeared. OOMK works fine now.

So I'm definitely leaving reiserfs due to the deadlocks; a pity, because it
served very well to me for many years. I'd be glad to use it again with fixed
deadlock troubles.

If it's of help of anyone, here is the log (since just before the OOMK) taken by
netconsole, linux 3.4.1, and with some sysrq dumps. Since the OOMK message
appears, the machine answers to nothing but sysrq requests.

The log:
http://viric.name/tmp/hang/sheevaplug-hang1.txt.gz

Regards,
Lluís.
