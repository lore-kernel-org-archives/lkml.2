Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0DGWeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:34:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50961 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0DGWeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:34:00 -0400
Message-ID: <4BBD07F9.5060106@zytor.com>
Date: Wed, 07 Apr 2010 15:32:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Rabin Vincent <rabin@rab.in>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15668] start_kernel(): bug: interrupts were enabled early
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.4LH.YtPvLB@chimera>
In-Reply-To: <JVS2s9dmTsP.A.4LH.YtPvLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 02:13 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15668
> Subject		: start_kernel(): bug: interrupts were enabled early
> Submitter	: Rabin Vincent <rabin@rab.in>
> Date		: 2010-03-25 19:53 (14 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
                                         ^^^^

FWIW, this /git is redundant.

	-hpa
