Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0GJKEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:04:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:52417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0GJKEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:04:50 -0400
Message-ID: <4C384580.2080507@kernel.org>
Date: Sat, 10 Jul 2010 12:03:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-pm@lists.osdl.org,
       stephan.diestelhorst@amd.com
Subject: Re: HDD not suspending properly / dead on resume
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007100104.38693.stephan.diestelhorst@gmail.com> <201007100206.13401.rjw@sisk.pl> <201007100850.36889.stephan.diestelhorst@gmail.com>
In-Reply-To: <201007100850.36889.stephan.diestelhorst@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 10 Jul 2010 10:03:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 08:50 AM, Stephan Diestelhorst wrote:
>> I have a box where this problem is kind of reproducible, but it happens _very_
>> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
>> loop.  Are you able to reproduce it more regurarly?
> 
> For me it is much more reproducible. If I run multiple direct writing
> dd-s to the disk in question I trigger it rather reliably (~75% or
> higher). See the attached script from an earlier email.
> Maybe that helps triggering your case more reliabl, too?

Can you please try the following git tree?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git libata-irq-expect

Thanks.

-- 
tejun
