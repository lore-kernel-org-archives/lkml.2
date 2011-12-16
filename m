Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab1LPEVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:21:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54397 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1LPEV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:21:29 -0500
MIME-Version: 1.0
In-Reply-To: <201112151747.28366.trenn@suse.de>
References: <1323879532-10490-1-git-send-email-standby24x7@gmail.com>
	<201112151747.28366.trenn@suse.de>
Date: Fri, 16 Dec 2011 13:21:28 +0900
Message-ID: <CALLJCT3hwYhCzrqbfeXG-C4t+PTG8fu_uJP=+S3H=tt4yX+D9w@mail.gmail.com>
Subject: Re: [PATCH] ACPI: kernel-parameters.txt : Add intel_idle.max_cstate
From: Masanari Iida <standby24x7@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        rdunlap@xenotime.net, lenb@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/16 Thomas Renninger <trenn@suse.de>:
> On Wednesday, December 14, 2011 05:18:52 PM Masanari Iida wrote:
>> Add missing intel_idle.max_cstate in kernel-parameters.txt
> I wonder whether this one should get documented at all.
>
My opinion is, as long as the kernel parameter is available,
we should document it.  And if developer want to guide the user to use
cpuidle.max_cstate, we should document so.

> Better would be to work towards a general cpuidle.max_state=
> param which deprecates processor.max_cstate= (acpi_idle driver) and
> intel_idle.max_cstate= and enables this functionality for all
> other cpuidle drivers out there as well.
>
cpuidle.max_state is also not in the kernel-parameters.txt,
Separate patch need to be created.

> Something to turn off intel_idle driver and favor the acpi_idle
> driver for debugging would still be needed then.
>
This patch explains how to disable intel_idle.
Although processor.max_cstate=0 sets cstate to 0,
but similar option intel_idle.max_cstate=0 didn't set cstate to 0.
This is confusing for the users.
This is the reason why I wanted to document it.

Masanari Iida
