Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2G1AsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 20:48:18 -0400
Received: from linux-sh.org ([111.68.239.195]:57774 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab2G1AsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 20:48:17 -0400
Date: Sat, 28 Jul 2012 09:48:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression, post-3.5] System suspend broken on the Mackerel
 board
Message-ID: <20120728004809.GH30468@linux-sh.org>
References: <201207280053.11701.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207280053.11701.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 12:53:11AM +0200, Rafael J. Wysocki wrote:
> Hi Paul,
> 
> Unfortunately, your commit
> 
> commit ca5481c68e9fbcea62bb3c78ae6cccf99ca8fb73
> Author: Paul Mundt <lethal@linux-sh.org>
> Date:   Tue Jul 10 12:08:14 2012 +0900
> 
>     sh: pfc: Rudimentary pinctrl-backed GPIO support.
> 
> breaks system suspend on the Mackerel board (.config attached).  The system
> simply doesn't suspend and instead it hangs somewhere while suspending
> devices (apparently before running the "late" callbacks).
> 
> If the above commit is reverted, system suspend works normally.
> 
Ok, I'll take a look at it on Monday, thanks for reporting.
