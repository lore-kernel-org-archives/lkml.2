Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1BTCqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 21:46:13 -0500
Received: from lo.gmane.org ([80.91.229.12]:46898 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab1BTCqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 21:46:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: supercilious.dude@gmail.com
Subject: Re: KSM kernel interface
Date: Sun, 20 Feb 2011 02:45:54 +0000
Message-ID: <ijpv94$j4d$1@dough.gmane.org>
References: <ijnfme$snp$1@dough.gmane.org> <alpine.LSU.2.00.1102191026070.5067@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 5ac0ec50.bb.sky.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
In-Reply-To: <alpine.LSU.2.00.1102191026070.5067@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch. I will try it out later today.

 >
 > > Perhaps there is a small kernel modification that might make this
 > possible
 > > or provide a sysfs flag that enables it (off by default of course)?
 >
 > Indeed it could be added if there were a general call for it; but ksmd
 > would tend to get wasteful, and the only call for it that I remember is
 > for testing.
 >
 > I expect you've noticed the transparent_hugepage/enabled "always" option,
 > and you are thinking something like that could be done for KSM: yes.
 >
 >

For what its worth, I believe that the option in sysfs to enable KSM
globally would be useful to have. I'm sure i'm not the only one. Its not
like it would be a great deal of overhead, since the KSM machinery is
already there anyway, just needs a flag to enable it at runtime instead 
of at boot.

I have at least one system running mostly legacy code that is according 
to ESXI's memory report, using only 400mb per gigabyte thanks to 
transparent page sharing. I would very much like to be able to have that 
level of memory saving on arbitrary code running on bare metal. 
Administrators can make their own judgement about ksmd's CPU usage, and 
the defaults already suit most people. I don't really see how having 
that extra flag (defaulting to off of course) would hurt.

Thanks

