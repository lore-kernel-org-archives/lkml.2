Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069Ab2FDWWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:22:16 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:25423 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2FDWWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:22:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 188.77.103.10
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Lmbp76Ll5PlPY8IShKk7c
Date: Tue, 5 Jun 2012 00:22:08 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Two hangs on reiserfs, linux 3.3.6
Message-ID: <20120604222208.GP1927@vicerveza.homeunix.net>
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

I use reiserfs since years and never saw it hang... but in this computer, that
has two reiserfs on soft RAID1, I've seen two hangs this week.

Here are the sysrq 'w' I could get from dmesg from the two situations, I hope
they can help finding out what can this be. All the system works (rootfs on
btrfs, two data reiserfs on softraid1), but attempts to use the reiserfs trees
end up in hanged processes.

http://viric.name/tmp/hang/nispro-dmesg-hang-reiserfs.txt.gz

http://viric.name/tmp/hang/nispro-dmesg-hang-reiserfs2.txt.gz - this, a few
minutes ago, includes all since boot.

Regards,
Lluís.
