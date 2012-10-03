Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab2JCQCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:02:24 -0400
Received: from 1wt.eu ([62.212.114.60]:35859 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989Ab2JCQCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:02:23 -0400
Date: Wed, 3 Oct 2012 18:01:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [ 008/180] 2.6.32.x: ntp: Fix leap-second hrtimer livelock
Message-ID: <20121003160151.GE3889@1wt.eu>
References: <20121001225157.951753597@1wt.eu> <1349275814.16173.13.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349275814.16173.13.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, Oct 03, 2012 at 03:50:14PM +0100, Ben Hutchings wrote:
> On Tue, 2012-10-02 at 00:52 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> [...]
> 
> No objection, but please remove the '2.6.32.x: ' prefix from the subject
> before committing this and the other ntp/timekeeping/hrtimer fixes.

Good point. Initially John used this as a differenciator when sending to
stable@ but I directly applied the mbox without fixing the subject, which
isn't a good thing.

Done!
Willy

