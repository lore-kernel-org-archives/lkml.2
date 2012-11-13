Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2KMQYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:24:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38974 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab2KMQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:24:35 -0500
Date: Tue, 13 Nov 2012 17:24:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting
 stats
Message-ID: <20121113162449.GE9327@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mark Langsdorf <mark.langsdorf@calxeda.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	MyungJoo Ham <myungjoo.ham@gmail.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com>
 <20121111163821.GA21635@x1.osrc.amd.com>
 <50A12565.4070701@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50A12565.4070701@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 10:35:49AM -0600, Mark Langsdorf wrote:
> The function is buried pretty deep in the cpufreq_stat code. It didn't
> seem appropriate to make it a function pointer as part of struct
> cpufreq_driver.

Right, what's cpufreq-speak for

	if (Calxeda)
		shift by 10

?

Better yet, add a flag or a bitfield called "minimize_jitter" or similar
and set it only on your hardware...

Thanks.

-- 
Regards/Gruss,
Boris.
