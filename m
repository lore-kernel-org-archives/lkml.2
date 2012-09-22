Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2IVV1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 17:27:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35732 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2IVV1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 17:27:41 -0400
Date: Sat, 22 Sep 2012 14:27:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120922212735.GG2934@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <505C33B9.8000807@gmail.com>
 <20120921121346.GD2458@linux.vnet.ibm.com>
 <505C6B03.7020305@gmail.com>
 <20120921151203.GA2454@linux.vnet.ibm.com>
 <505C855F.3060301@gmail.com>
 <505D7621.4040505@gmail.com>
 <20120922150913.GA2934@linux.vnet.ibm.com>
 <505DDBE7.7010706@gmail.com>
 <20120922155613.GB2934@linux.vnet.ibm.com>
 <505DFA65.3080805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505DFA65.3080805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092221-6148-0000-0000-000009E7EFED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 07:50:29PM +0200, Sasha Levin wrote:
> On 09/22/2012 05:56 PM, Paul E. McKenney wrote:
> > And now the prime suspect is the new CONFIG_RCU_USER_QS=y.  Do these
> > warnings ever show up with CONFIG_RCU_USER_QS=n?
> 
> It seems that disabling that does make the warnings go away.
> 
> I'll keep the tests running in case it just reduces the chances or something
> like that.

Thank you for testing this!

And of course the reason that I didn't see these problems is that I
failed to update my tests to enable CONFIG_RCU_USER_QS.  :-/

							Thanx, Paul

