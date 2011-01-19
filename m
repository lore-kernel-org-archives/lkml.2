Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1ASQdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:33:31 -0500
Received: from lo.gmane.org ([80.91.229.12]:47226 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1ASQda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:33:30 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: 2.6.37-08009-ge6f597a "feels" slow - rhythmbox skips audio
Date: Wed, 19 Jan 2011 08:33:07 -0800
Message-ID: <ih73o4$gnf$1@dough.gmane.org>
References: <1295395790.3327.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-177-217.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b10pre) Gecko/20110117 Thunderbird/3.3a2
In-Reply-To: <1295395790.3327.9.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 04:09 PM, Thomas Meyer wrote:
> hi,
>
> kernel version 2.6.37-08009-ge6f597a "feels" slow and background audio
> skips/stalls when performing some cpu (and/or io?) intensive tasks like
> a kernel compile or grepping for a string in the kernel source or
> upgrading the system via yum upgrade.
>
> I didn't see this behaviour with 2.6.37 (and previous versions) on my UP
> system.

I see the same on my UP machine (but not SMP) when using the new
SCHED_AUTOGROUP feature.  Do you have that enabled?


