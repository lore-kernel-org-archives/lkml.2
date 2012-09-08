Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2IHSVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:21:16 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44231 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2IHSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120908175920.GI10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
	<20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
	<20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF52HQgrVEQFeOhQc=y+iFbc55-X9TC96wVvoV6g77Ze=Eg@mail.gmail.com>
	<20120908175920.GI10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 02:21:15 +0800
Message-ID: <CACvQF50FPbjKP3Rz8r9PtZuoySqJnif3vKNfwcBmBr9wApziJQ@mail.gmail.com>
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hmmm... so, I'm having some difficulty communicating with you.  We
> need two separate patch series.  One for for-3.6-fixes and the other
> for restructuring on top of for-3.7 after the fixes are merged into
> it.
>
> As you currently posted, the patches are based on for-3.7 and fixes
> and restructuring are intermixed, so I'm asking you to separate out
> two patches to fix the idle depletion bug and base them on top of
> for-3.6-fixes.  Am I misunderstanding something?
>


Patch 3,4 are ready for 3.6 and they can be applied to 3.6 directly.
don't need to revise nor resend.
you just pick them up to for-3.6-fixes.

Thanks.
Lai
