Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0CaBQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0CaBP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:15:58 -0400
Date: Tue, 30 Mar 2010 21:15:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, mcarlson@broadcom.com,
       "David S. Miller" <davem@davemloft.net>,
       Mike Pagano <mpagano@gentoo.org>, Michael Chan <mchan@broadcom.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [007/116] tg3: Fix 5906 transmit hangs
Message-ID: <20100330211522.2f1658fe@redhat.com>
In-Reply-To: <20100330225600.398306625@linux.site>
References: <20100330230600.GA28802@kroah.com>
	<20100330225600.398306625@linux.site>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 15:54:45 -0700
Greg KH <gregkh@suse.de> wrote:

> 2.6.32-stable review patch.  If anyone has any objections, please let
> us know.
> 
> ------------------
> 
> From: Matt Carlson <mcarlson@broadcom.com>
> 
> This is a resubmit backport of commit
> 92c6b8d16a36df3f28b2537bed2a56491fb08f11 to kernel version 2.6.32.
> The gentoo bug report can be found at
> https://bugs.gentoo.org/show_bug.cgi?id=301091. Thanks to Matt
> Carlson for his assistance and working me to fix a regression caused
> by the initial patch.  The original description is as follows:
> 

I think these two patches should be used instead, as they fix the
bug without needing backports and keep the driver closer to upstream:

0e1406dd404ce55dbe8d68b4b5e2aed7e5c75fdb
"tg3: Assign flags to fixes in start_xmit_dma_bug"

92c6b8d16a36df3f28b2537bed2a56491fb08f11
"tg3: Fix 5906 transmit hangs"
