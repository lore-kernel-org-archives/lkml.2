Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2I0Uoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:44:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35130 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2I0Uoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:44:54 -0400
Date: Thu, 27 Sep 2012 13:44:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] 3.0-stable timekeeping fixes merged in 3.6
Message-ID: <20120927204450.GE19489@kroah.com>
References: <1347410993-19004-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347410993-19004-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 08:49:50PM -0400, John Stultz wrote:
> Just wanted to send out a few timekeeping fixes that were merged
> in 3.6 which are appropriate for -stable.
> 
> This queue backports the following fixes:
> -----------------------------------------
> cee58483cf56e0ba355fdd97ff5e8925329aa936    time: Move ktime_t overflow checking into timespec_valid_strict
> bf2ac312195155511a0f79325515cbb61929898a    time: Avoid making adjustments if we haven't accumulated anything
> 4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b    time: Improve sanity checking of timekeeping inputs
> 
> I've run these through my timetest suite w/ kvm on both i386
> & x86_64. But more testing would be of course appreciated.
> 	https://github.com/johnstultz-work/timetests

All applied, thanks.

greg k-h
