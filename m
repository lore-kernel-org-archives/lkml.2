Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2AVSEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:04:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49519 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2AVSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:03:25 -0500
Message-ID: <4F1C4F62.9060309@gmail.com>
Date: Sun, 22 Jan 2012 20:03:14 +0200
From: Mantas <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.suspend.devel,gmane.linux.kernel
To: Srivatsa Bhat <srivatsasbhat@gmail.com>
CC: maciej.rutecki@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        suspend-devel@lists.sourceforge.net,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: 3.2-git - freeze during hibernation
References: <jepbo0$l1e$1@dough.gmane.org> <201201220905.10710.maciej.rutecki@gmail.com> <CAE368AS+FjoTvtBT0A2Qa0RXrJYbgxNdv6OOvD3cnmsTrLsRyQ@mail.gmail.com>
In-Reply-To: <CAE368AS+FjoTvtBT0A2Qa0RXrJYbgxNdv6OOvD3cnmsTrLsRyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-22 10:32, Srivatsa Bhat wrote:
> Could you please try the patch posted at:
> https://lkml.org/lkml/2012/1/19/177 ?

Also tested linux git-v3.3-rc1 (currently latest); hibernation now works
fine with the patch posted.

-- 
Mantas M.
