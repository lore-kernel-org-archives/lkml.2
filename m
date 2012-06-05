Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2FETum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:50:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14836 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2FETuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:50:40 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 188.77.103.10
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1//af7o6EOadTA4GhAkSihA
Date: Tue, 5 Jun 2012 21:50:34 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Two hangs on reiserfs, linux 3.3.6
Message-ID: <20120605195034.GY1927@vicerveza.homeunix.net>
References: <20120604222208.GP1927@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120604222208.GP1927@vicerveza.homeunix.net>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 12:22:08AM +0200, Lluís Batlle i Rossell wrote:
> Hello,
> 
> I use reiserfs since years and never saw it hang... but in this computer, that
> has two reiserfs on soft RAID1, I've seen two hangs this week.
> 
> Here are the sysrq 'w' I could get from dmesg from the two situations, I hope
> they can help finding out what can this be. All the system works (rootfs on
> btrfs, two data reiserfs on softraid1), but attempts to use the reiserfs trees
> end up in hanged processes.
> 
> http://viric.name/tmp/hang/nispro-dmesg-hang-reiserfs.txt.gz
> 
> http://viric.name/tmp/hang/nispro-dmesg-hang-reiserfs2.txt.gz - this, a few
> minutes ago, includes all since boot.

Third hang, some minutes ago. Only two processes stuck.
http://viric.name/tmp/hang/nispro-dmesg-hang-reiserfs3.txt

I think I'm moving away from reiserfs.
