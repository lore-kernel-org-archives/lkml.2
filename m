Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0H2XYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:24:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45779 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0H2XYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:24:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Hill" <hilld@binarystorm.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.vDE.diueMB@chimera>
Date: Sun, 29 Aug 2010 16:24:06 -0700
In-Reply-To: <ByD_7B96czP.A.vDE.diueMB@chimera> (Rafael J. Wysocki's message
	of "Mon, 30 Aug 2010 00:57:48 +0200 (CEST)")
Message-ID: <m11v9hc8a1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
Subject: Re: [Bug #16173] After uncompressing the kernel, at boot time, the server hangs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>

Looks like it's fixed.

Eric

"David Hill" <hilld@binarystorm.net> writes:
> Date: Thu, 12 Aug 2010 23:09:52 -0700
> 
> Eureka!
> 
>    This seems to solve my problem!  My Dual P3-500MHZ is now booting with that
> patch.
> 
> Good work guys!!!!
> 
> Thank you very much,


>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16173
> Subject		: After uncompressing the kernel, at boot time, the server hangs.
> Submitter	: David Hill <hilld@binarystorm.net>
> Date		: 2010-06-09 23:25 (82 days old)
> First-Bad-Commit: http://git.kernel.org/linus/cf7500c0ea133d66f8449d86392d83f840102632
> Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
