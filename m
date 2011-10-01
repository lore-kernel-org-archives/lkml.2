Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1JAWYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:24:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42025 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1JAWYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:24:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH v13 0/4] Devfreq, DVFS Framework for Non-CPU Devices
Date: Sun, 2 Oct 2011 00:26:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Nishanth Menon <nm@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com> <201109302244.37584.rjw@sisk.pl> <87wrcpehhd.fsf@ti.com>
In-Reply-To: <87wrcpehhd.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110020026.55600.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 01, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Thursday, September 29, 2011, MyungJoo Ham wrote:
> >> Summary of update from the patchset v12:
> >> 
> >> - Bugfix: _remove_devfreq and devfreq_dev_release may be called multiple times.
> >> 
> >> - Fixup kerneldoc comments.
> >> 
> >> Reposting to LKML as Kernel-PM list seems broken.
> >> 
> >> I didn't put Kevin's ACK at 2/4 patch as there has been changes in 2/4 patch
> >> (the bugfix mentioned above).
> 
> Looks fine to me.
> 
> Rafael, feel free to add my Ack to 2/4 if you like.

Done.

Thanks,
Rafael
