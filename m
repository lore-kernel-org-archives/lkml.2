Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2KKQiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 11:38:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45762 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2KKQiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 11:38:20 -0500
Date: Sun, 11 Nov 2012 17:38:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting
 stats
Message-ID: <20121111163821.GA21635@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mark Langsdorf <mark.langsdorf@calxeda.com>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@gmail.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 12:32:43PM -0600, Mark Langsdorf wrote:
> When collecting stats, if a frequency doesn't match the table, go through
> the table again with both the search frequency and table values shifted
> left by 10 bits.

Why would that second pass succeed?

And why is this in generic code (I'm assuming this is a Calxeda-specific
case)?

-- 
Regards/Gruss,
Boris.
