Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab0E1Qib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:38:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:42260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0E1Qi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:38:29 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH] x86 cpufreq: Make trace_power_frequency cpufreq driver independent
Date: Fri, 28 May 2010 18:39:15 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       robert.schoene@tu-dresden.de, cpufreq@vger.kernel.org,
       linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org,
       x86@kernel.org
References: <1274791199-12335-1-git-send-email-trenn@suse.de> <201005251453.06111.trenn@suse.de>
In-Reply-To: <201005251453.06111.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005281839.15563.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 25 May 2010 14:53:05 Thomas Renninger wrote:
> Hi Ingo,
> 
> this is in fact a resend. First version was sent on 2010-04-30.

Andrew: could you eventually queue this one until it gets
picked up.
Robert and myself invested quite some time to fix
trace_power_frequency for most Intel server CPUs and now it
should also work for any arbitrary CPU freq driver.

Thanks,

       Thomas

PS: I won't be able to answer for one week.
