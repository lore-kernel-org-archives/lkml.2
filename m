Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0ERS5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:57:34 -0400
Received: from mail.perches.com ([173.55.12.10]:2341 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab0ERS5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:57:33 -0400
Subject: Re: Hardware Error Kernel Mini-Summit
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
In-Reply-To: <87eih9xd4m.fsf@basil.nowhere.org>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com>
	 <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home>
	 <87eih9xd4m.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 11:57:31 -0700
Message-ID: <1274209051.17703.110.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 20:45 +0200, Andi Kleen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Tue, 2010-05-18 at 13:44 -0300, Mauro Carvalho Chehab wrote:
> >> IMO, the first
> >> step is to provide an error core integrated to perf, and then start
> >> integrating the several error systems around it.
> > Why integrated to perf?
> For a different perspective on this see also
> http://permalink.gmane.org/gmane.linux.kernel/952061
> 
> AFAIK all the issues mentioned there are still open.

Yup, that's why I asked for explanation.

What was offered lacks useful goal and design detail.

perf is a cool tool, but probably not necessary for
for a HW error reporting system.


