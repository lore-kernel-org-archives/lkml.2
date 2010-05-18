Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0ERR7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0ERR7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:59:43 -0400
Message-ID: <4BF2D564.7010101@redhat.com>
Date: Tue, 18 May 2010 14:59:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com>	 <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home>
In-Reply-To: <1274204560.17703.82.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2010-05-18 at 13:44 -0300, Mauro Carvalho Chehab wrote:
>> IMO, the first
>> step is to provide an error core integrated to perf, and then start
>> integrating the several error systems around it.
> 
> Why integrated to perf?

That's the original plan. It were suggested by Ingo and Thomas at LKML. Borislav
also send a more technical proposal about it.

It actually makes sense, since some sorts of errors may affect performance
(those non-fatal errors that are auto-recovered). Also, using debugfs and the
same kind of logic used by perf to filter errors seems pertinent for hardware 
errors. As the actual patches were not written yet, the details on how those 
things will integrate will depend on further analysis.

-- 

Cheers,
Mauro
