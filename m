Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2LPQTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 11:19:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44467 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab2LPQTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 11:19:35 -0500
Date: Sun, 16 Dec 2012 08:19:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121216161921.GO2542@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <alpine.LNX.2.01.1212160527210.17128@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212160527210.17128@nerf07.vanv.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121616-9360-0000-0000-00000E035BCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 05:29:21AM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2012-10-03 18:17, Greg Kroah-Hartman wrote:
> >> 
> >> OK, I will bite...  How should I flag an option that is initially only
> >> intended for those willing to take some level of risk?
> >
> >In the text say "You really don't want to enable this option, use at
> >your own risk!"  Or something like that :)
> 
> You know that won't not work, just like "everybody is encouraged
> to upgrade" for -stable. It needs to say "All users must disable this!"

The thought expressed earlier in this thread of unconditionally splatting
during boot seemed pretty compelling to me.  ;-)

							Thanx, Paul

