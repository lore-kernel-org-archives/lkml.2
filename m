Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2JJMvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:51:23 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40214 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2JJMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121010124839.GA22448@alberich>
References: <20121009193844.GC7724@alberich>
	<20121010124839.GA22448@alberich>
Date: Wed, 10 Oct 2012 21:51:17 +0900
X-Google-Sender-Auth: M6j7MANoeJyM5SHr3he3PvMFWk8
Message-ID: <CAOS58YML9s-FJJektV1iFbz-Hr3bCq_RUppZfqb+pbHAJ+tOCA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, powernow-k8: Fix usage of smp_processor_id() in
 preemptible code
From: Tejun Heo <tj@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 10, 2012 at 9:48 PM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> Please ignore my patch. It was insufficiently tested -- sorry for this.
> (powernowk8_target_fn might sleep).
>
> Have to take a closer look how to avoid below issue.

Probably the only thing which can be done is always bouncing to the
percpu work item.

Thanks.

-- 
tejun
