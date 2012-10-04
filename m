Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab2JDOdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:33:23 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41833 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965091Ab2JDOdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:33:21 -0400
Date: Thu, 4 Oct 2012 07:31:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121004143150.GA2464@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
 <20121003200314.GR2527@linux.vnet.ibm.com>
 <20121004015539.GA19958@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004015539.GA19958@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100414-1976-0000-0000-00001203882F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 02:55:39AM +0100, Matthew Garrett wrote:
> On Wed, Oct 03, 2012 at 01:03:14PM -0700, Paul E. McKenney wrote:
> 
> > That has not proven sufficient for me in the past, RCU_FAST_NO_HZ
> > being a case in point.
> 
> Taint the kernel at boot time? That'd be sufficient to force distros to 
> disable it.

Cool!  That does sound much more socially responsible than my thought
of forcing a splat (e.g., WARN_ON(1)) during boot.  ;-)

							Thanx, Paul

