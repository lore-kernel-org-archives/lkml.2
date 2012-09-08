Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2IHR70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:59:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IHR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:59:24 -0400
Date: Sat, 8 Sep 2012 10:59:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
Message-ID: <20120908175920.GI10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
 <20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
 <20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF52HQgrVEQFeOhQc=y+iFbc55-X9TC96wVvoV6g77Ze=Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52HQgrVEQFeOhQc=y+iFbc55-X9TC96wVvoV6g77Ze=Eg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 01:56:47AM +0800, Lai Jiangshan wrote:
> > So, your worry was incorrect and the above is what we're gonna do, no?
> 
> NO BUG found for PATCH4 even idle rebinding is synchronous.

Hmmm... so, I'm having some difficulty communicating with you.  We
need two separate patch series.  One for for-3.6-fixes and the other
for restructuring on top of for-3.7 after the fixes are merged into
it.

As you currently posted, the patches are based on for-3.7 and fixes
and restructuring are intermixed, so I'm asking you to separate out
two patches to fix the idle depletion bug and base them on top of
for-3.6-fixes.  Am I misunderstanding something?

Thanks.

-- 
tejun
