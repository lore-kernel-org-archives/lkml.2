Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0EGXnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:43:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57077 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab0EGXnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:43:47 -0400
Subject: Re: 2.6.33.3-rt19 kernel BUG's
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.LFD.2.00.1005071240350.3401@localhost.localdomain>
References: <1273197218.6768.10.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1005071240350.3401@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 16:43:41 -0700
Message-ID: <1273275821.2776.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 12:41 +0200, Thomas Gleixner wrote:
> On Thu, 6 May 2010, Fernando Lopez-Lezcano wrote:
> 
> CC'ed John and Nick
> 
> > See below... just trying to boot (quad core desktop machine).

Ok. Got this to reproduce. Will hopefully have a fix for your soon.

Thanks for the bug report!
-john


