Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2ISEuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:50:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2ISEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:50:51 -0400
Date: Wed, 19 Sep 2012 06:50:39 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
Message-ID: <20120919045038.GA2248@netboy.at.omicron.at>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org>
 <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5058BD9E.30909@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:29:50AM -0700, John Stultz wrote:
> I believe its mostly historical, but on some architectures that
> history has become an established ABI, making it technical.

Fine, but what do you mean by "ABI?" Are you talking about magic
addresses for functions?

Without knowing the dirty details, what I imagine is a jump/branch
from the arch-specific code into the common implementation.

Can that be done?

Thanks,
Richard
