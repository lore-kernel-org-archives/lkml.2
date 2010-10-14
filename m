Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0JNQm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:42:26 -0400
Received: from mail.digium.com ([216.207.245.2]:42792 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab0JNQmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:42:25 -0400
X-Greylist: delayed 1698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2010 12:42:25 EDT
Message-ID: <4CB72BF3.4030601@digium.com>
Date: Thu, 14 Oct 2010 11:12:35 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Proper kernel irq time accounting -v4
References: <1286237003-12406-1-git-send-email-venki@google.com>
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 07:03 PM, Venkatesh Pallipadi wrote:
> Solution to (1) involves adding extra timing on irq entry/exit to
> get the fine granularity info and then exporting it to user.
> The following patchset addresses this problem in a way similar to [2][3].
> Keeps most of the code that does the timing generic
> (CONFIG_IRQ_TIME_ACCOUNTING), based off of sched_clock(). And adds support for
> this in x86. This time is not yet exported to userspace yet. Patch for that
> coming soon.
> 

Would you be willing to share your thoughts on how you plan to export
this information to userspace?

I applied this set to one of my machines in hopes of seeing more
accurate hi time before I noticed that in the quoted paragraph you said
this is still forthcoming.

Thanks,
Shaun
