Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2JFSnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:43:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40364 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2JFSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:43:04 -0400
Message-ID: <50707BB0.8050301@kernel.org>
Date: Sat, 06 Oct 2012 14:42:56 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Lv Zheng <lv.zheng@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND PATCH v4 0/2] ACPI: DBGP/DBG2 early console support for
 LPIA.
References: <cover.1347453194.git.zetalog@gmail.com> <cover.1348652044.git.lv.zheng@intel.com> <5065457E.4040500@zytor.com>
In-Reply-To: <5065457E.4040500@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You want to take this, or should I?

go ahead and take the series in tip 3.8, Peter, thanks.

I looked over this series a while back and my feedback was that
it should be disabled by default and enabled by bootparam --
like other earlyprink -- else an issue here would render
a system un-bootable.  I see that LV has addressed that
in the latest version.

LV,
have you addressed the feedback from Konrad?

thanks,
-Len


