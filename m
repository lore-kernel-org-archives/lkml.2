Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1AYWcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:32:51 -0500
Received: from mailout02.t-online.de ([194.25.134.17]:57216 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1AYWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:32:50 -0500
Message-ID: <4D3F4F86.5080207@t-online.de>
Date: Tue, 25 Jan 2011 23:32:38 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/sdvo: If at first we dont succeed in reading
 the response, wait
References: <4D3EB90C.9020901@t-online.de> <1295967967-26041-1-git-send-email-chris@chris-wilson.co.uk> <4D3F4849.4030905@t-online.de> <b7da2f$q83ub3@fmsmga001.fm.intel.com>
In-Reply-To: <b7da2f$q83ub3@fmsmga001.fm.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: bRm6ZMZSZhQ-UxV9Xja+RTJQEUuzleLDkMrC2THtnhDGbkVi+Pqz4wbIEJXK0sMgZ5
X-TOI-MSGID: 4069008f-5e07-4753-9437-d398c355bb9e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.01.2011 23:11, schrieb Chris Wilson:
> On Tue, 25 Jan 2011 23:01:45 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
>   
>> I think that patch also should be a candidate for 2.6.37.1 as it fixes a
>> regression
>> introduced in 2.6.37.
>>     
> (Actually I think the bug is older than that...)
>   

You are right, but I used 2.6.31.14 for a long time. After feeling the need
to change I found 2.6.32 to 2.6.35 to be unusuable on my system, 2.6.36.3
is ok with the lvds patch I submitted for my i915GMm-HFS mobos.

I think tomorrow I will try to find some more information on the X crash
caused by enabling automated cgroup scheduling in .38-rc*

Knut
