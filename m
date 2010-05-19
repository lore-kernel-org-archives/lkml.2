Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0ESLza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0ESLz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:55:28 -0400
Message-ID: <4BF3D17F.5000605@redhat.com>
Date: Wed, 19 May 2010 08:54:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <bp@amd64.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: Re: Hardware Error Kernel Mini-Summit
References: <4BF2392A.9040409@jp.fujitsu.com> <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519064619.GA30320@aftab> <20100519070919.GA9618@elte.hu>
In-Reply-To: <20100519070919.GA9618@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Regarding dmesg, there's a WIP patch on lkml that 
> integrates printks into this framework as well - makes 
> each printk also available as a special string event.
> 
> That way a tool can have both programmatic access to 
> printk output (without having to interact with the syslog 
> buffer itself) - together with all the other structured 
> log sources, while humans can also see what is happening.

Some system admins prefer to have everything on dmesg, as they
can enable a serial console, and catch the logs remotely, even
when the machine crashes for example due to a hardware failure.

So, IMHO, one feature that the perf event needs is the capability
to report errors via a serial console also, or a mechanism where
some events are sent via dmesg.

-- 

Cheers,
Mauro
