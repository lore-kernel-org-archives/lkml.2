Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab0ERSpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:45:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0ERSpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:45:31 -0400
To: Joe Perches <joe@perches.com>
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
Subject: Re: Hardware Error Kernel Mini-Summit
From: Andi Kleen <andi@firstfloor.org>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com>
	<4BF2C3D1.10009@redhat.com>
	<1274204560.17703.82.camel@Joe-Laptop.home>
Date: Tue, 18 May 2010 20:45:29 +0200
In-Reply-To: <1274204560.17703.82.camel@Joe-Laptop.home> (Joe Perches's message of "Tue\, 18 May 2010 10\:42\:40 -0700")
Message-ID: <87eih9xd4m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Tue, 2010-05-18 at 13:44 -0300, Mauro Carvalho Chehab wrote:
>> IMO, the first
>> step is to provide an error core integrated to perf, and then start
>> integrating the several error systems around it.
>
> Why integrated to perf?

For a different perspective on this see also

http://permalink.gmane.org/gmane.linux.kernel/952061

AFAIK all the issues mentioned there are still open.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
