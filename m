Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1GEWkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:40:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60166 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1GEWkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:40:21 -0400
Message-ID: <4E1392BA.8010708@zytor.com>
Date: Tue, 05 Jul 2011 15:39:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: give names to realmode wakeup flags
References: <1309818953-769-1-git-send-email-kees.cook@canonical.com> <1309818953-769-2-git-send-email-kees.cook@canonical.com>
In-Reply-To: <1309818953-769-2-git-send-email-kees.cook@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 03:35 PM, Kees Cook wrote:
> Instead of using literals, use a common set of names for the
> user-controlled realmode wakeup flags.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

I'm sorry, but I really have to complain about this:

This was a very unfriendly thing to do.  You took a patch that is a bug
fix to be considered for -stable, and you applied it *on top of a
cleanup patch*.  They should not have been part of the same patchset,
but *certainly* not in that order.

Please resubmit.

	-hpa
