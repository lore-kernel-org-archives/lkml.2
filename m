Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1I3XaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:30:15 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:41043 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1I3XaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:30:10 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Nishanth Menon <nm@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v13 0/4] Devfreq, DVFS Framework for Non-CPU Devices
Organization: Texas Instruments, Inc.
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
	<201109302244.37584.rjw@sisk.pl>
Date: Fri, 30 Sep 2011 16:30:06 -0700
In-Reply-To: <201109302244.37584.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 30 Sep 2011 22:44:37 +0200")
Message-ID: <87wrcpehhd.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday, September 29, 2011, MyungJoo Ham wrote:
>> Summary of update from the patchset v12:
>> 
>> - Bugfix: _remove_devfreq and devfreq_dev_release may be called multiple times.
>> 
>> - Fixup kerneldoc comments.
>> 
>> Reposting to LKML as Kernel-PM list seems broken.
>> 
>> I didn't put Kevin's ACK at 2/4 patch as there has been changes in 2/4 patch
>> (the bugfix mentioned above).

Looks fine to me.

Rafael, feel free to add my Ack to 2/4 if you like.

Kevin
