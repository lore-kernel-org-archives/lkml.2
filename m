Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1L1EiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 23:38:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43198 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1L1Eh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 23:37:58 -0500
Date: Tue, 27 Dec 2011 20:29:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
Message-ID: <20111228042959.GA2477@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <1324977203.28904.1.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324977203.28904.1.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11122804-5112-0000-0000-0000037BDFB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 11:13:23AM +0200, Sasha Levin wrote:
> On Mon, 2011-12-26 at 08:31 -0800, Paul E. McKenney wrote:
> > Except that when I try looking for task_notify_func() in current mainline,
> > I get nothing.
> > 
> > Where is task_notify_func() coming from? 
> 
> I was testing linux-next, it actually comes from the android tree:
> drivers/staging/android/lowmemorykiller.c

That does sound familiar...  I wonder if the stuff in staging is current
Android or historical stuff.

							Thanx, Paul

