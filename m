Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1KDA1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:27:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58402 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1KDA1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:27:13 -0400
Date: Thu, 3 Nov 2011 17:27:08 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH pm-for-3.2 2/2] freezer: revert 27920651fe "PM /
 Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111104002708.GV4417@google.com>
References: <20111103230749.GS4417@google.com>
 <201111040113.21514.rjw@sisk.pl>
 <20111104001759.GU4417@google.com>
 <201111040124.34015.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111040124.34015.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 01:24:33AM +0100, Rafael J. Wysocki wrote:
> > Just to be sure, as the commit which changed fake_signal_wake_up() to
> > use KILLABLE wakeup is already mainline, these two will have to be
> > pushed as fixes after some time in this devel cycle.
> 
> Yes, they are 3.2 material and I'm going to push them in the next few days
> along with a number of other PM-related fixes/cleanups.  Is that OK?

Yeap, definitely.  Just got a bit worried that it was going into
linux-next.  Thanks. :)

-- 
tejun
