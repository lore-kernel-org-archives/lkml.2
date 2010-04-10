Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0DJXqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 19:46:15 -0400
Received: from smtpout2.superonline.com ([212.252.122.228]:62955 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0DJXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 19:46:14 -0400
Message-ID: <4BC10DBB.70205@superonline.com>
Date: Sat, 10 Apr 2010 19:46:03 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100405 Icedove/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: [Bug #15585] [Bisected Regression in 2.6.32.8] i915 with KMS enabledcauses memorycorruption when resuming from suspend-to-disk
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera> <onZ81XwyNTD.A.ENC.QEmvLB@chimera>
In-Reply-To: <onZ81XwyNTD.A.ENC.QEmvLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 165 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -26.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/10 07:04 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15585
> Subject		: [Bisected Regression in 2.6.32.8] i915 with KMS enabled causes memorycorruption when resuming from suspend-to-disk
> Submitter	: M. Vefa Bicakci <bicave@superonline.com>
> Date		: 2010-03-13 5:11 (27 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/d8e0902806c0bd2ccc4f6a267ff52565a3ec933b
> Message-ID	: <4B9B1E8F.5090806@superonline.com>
> References	: http://marc.info/?l=linux-kernel&m=126845754409543&w=2

Dear Rafael J. Wysocki,

I tested vanilla 2.6.33.2 and 2.6.34-rc3-git10, and unfortunately
both of them *have* this issue. So it looks like the issue has not
been resolved yet. Please keep this regression in the list of known
regressions.

Just to let you know: I am currently running 2.6.33.2 with the above-
mentioned commit reverted, and hibernate-thaw cycles work properly.

Regards,

M. Vefa Bicakci

Note: Please include me in the CC list when replying to this e-mail
as I am currently not subscribed to the LKML.
