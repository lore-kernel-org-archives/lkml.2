Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0CZD7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:59:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:32937 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0CZD7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:59:36 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "John Kacur" <jkacur@redhat.com>
Subject: Re: [Bug #15319] [BUG]: Possibe recursive locking detected in sysfs
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
	<hTwaxgnIZ2O.A.iYE.FPopLB@chimera>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 20:59:30 -0700
In-Reply-To: <hTwaxgnIZ2O.A.iYE.FPopLB@chimera> (Rafael J. Wysocki's message of "Sun\, 21 Mar 2010 21\:30\:49 +0100 \(CET\)")
Message-ID: <m1vdcjohr1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: rjw@sisk.pl, jkacur@redhat.com, maciej.rutecki@gmail.com, kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15319
> Subject		: [BUG]: Possibe recursive locking detected in sysfs
> Submitter	: John Kacur <jkacur@redhat.com>
> Date		: 2010-02-11 17:11 (39 days old)
> Message-ID	: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=126590832432598&w=2
> Handled-By	: Eric Biederman <ebiederm@aristanetworks.com>

The false positives I introduced should be fixed as of 2.6.34-rc2.
If this bug still shows up in 2.6.34-rcX it indicates a real bug.

Eric

