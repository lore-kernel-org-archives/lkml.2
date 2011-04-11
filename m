Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1DKSuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab1DKSux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:50:53 -0400
Date: Mon, 11 Apr 2011 20:50:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
	'shared_pending'
Message-ID: <20110411185005.GA4240@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-2-git-send-email-matt@console-pimps.org> <20110405201958.GA1404@redhat.com> <20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com> <20110406125757.GA12099@redhat.com> <20110406141548.1e0736ce@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406141548.1e0736ce@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Matt Fleming wrote:
>
> Yeah, good point. This patch definitely needs dropping from the series.

Yes.

Sorry for delay again. I'll try to read the rest of this series tomorrow,
I can no longer look at signal.c to today.

Oh, these changes do not look trivial. I must admit, I am a bit sceptical,
but this is only my first impression based on amount on changes and more
complex locking.

Oleg.

