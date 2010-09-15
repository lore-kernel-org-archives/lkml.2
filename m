Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0IOMtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:49:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52760 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0IOMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:49:46 -0400
Date: Wed, 15 Sep 2010 15:48:31 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Tony Luck <tony.luck@intel.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
Message-ID: <20100915124831.GB27658@esdhcp04044.research.nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com> <AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 Sep 2010 12:49:38.0175 (UTC) FILETIME=[74EE10F0:01CB54D4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/10 01:18 +0200, ext Tony Luck wrote:
> On Fri, Sep 10, 2010 at 3:40 AM, Phil Carmody
> <ext-phil.2.carmody@nokia.com> wrote:
> > Alas I have no way to test this patch.
> 
> Phil,
> 
> I have this built and booted on an ia64 ... what do you want me to measure? The
> number of iterations in:
> 
>   for (table = unw.tables; table; table = table->next)
> 
> before we find the right table to look?

Yes, that's the one. Sorry I wasn't more explicit.

Phil
