Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0JUK7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:59:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:59161 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043Ab0JUK7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:59:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: 2.6.36-ck1
Date: Thu, 21 Oct 2010 13:58:59 +0300
Organization: Lucas Barks
Message-ID: <i9p6df$v0$1@dough.gmane.org>
References: <201010211208.54401.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-375327.home.otenet.gr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Thunderbird/3.1.5
In-Reply-To: <201010211208.54401.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 04:08 AM, Con Kolivas wrote:
> These are patches designed to improve system responsiveness and interactivity
> with specific emphasis on the desktop, but suitable to any workload.
>
>
> Apply to 2.6.36:
> http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.36/2.6.36-ck1/patch-2.6.36-ck1.bz2

Thanks for updating your patches.  Applied to Gentoo's 2.6.36 and works 
as advertised so far.


> Those following the development of the patches for interactivity at massive
> load, I have COMPLETELY DROPPED them as they introduce regressions at normal
> workloads, and I cannot under any circumstances approve changes to improve
> behaviour at ridiculous workloads which affect regular ones. I still see
> precisely zero point at optimising for absurd workloads. Proving how many
> un-niced jobs you can throw at your kernel compiles is not a measure of one's
> prowess. It is just a mindless test.

I never felt the need for a "make -j256" on my Core2 Duo, so losing that 
"functionality" is of no consequence, at least here.

