Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0KYQLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:11:19 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:33445 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0KYQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:11:16 -0500
Date: Thu, 25 Nov 2010 11:10:58 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: i915: display doesn't get on back after returning from standby
 in 2.6.27-rc*
Message-ID: <20101125161058.GA5831@elliptictech.com>
References: <20101123123234.GA3791@tiehlicka.suse.cz>
 <20101125155828.GC9754@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125155828.GC9754@tiehlicka.suse.cz>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-25 16:58 +0100, Michal Hocko wrote:
> [Let's add Rafael for regression tracking]
> 
> On Tue 23-11-10 13:32:34, Michal Hocko wrote:
> > Hi,
> > since early 2.6.37 (I haven't bisected when exactly) my screen doesn't
> > get on after it got into standby mode. I have to either change to a
> > text console and back (if it gets to standby by the screen saver) or
> > close the lid on my laptop if I try:
> > xset dpms force standby
[...]
> > Is this a known issue?

I suspect that all of the following are the same issue:

  https://bugzilla.kernel.org/show_bug.cgi?id=23122
  https://bugzilla.kernel.org/show_bug.cgi?id=23472
  https://bugs.freedesktop.org/show_bug.cgi?id=31803

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
