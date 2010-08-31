Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0HaOlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:41:00 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.166]:33524 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757491Ab0HaOlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:41:00 -0400
Message-ID: <4C7D146E.8020601@superonline.com>
Date: Tue, 31 Aug 2010 17:40:46 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bug #16771] [Bisected Regression in 2.6.35] A full tmpfs filesystemcauses hibernationto hang
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.oHB.0bueMB@chimera>
In-Reply-To: <ByD_7B96czP.A.oHB.0bueMB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/10 02:13 AM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16771
> Subject		: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
> Submitter	: M. Vefa Bicakci <bicave@superonline.com>
> Date		: 2010-08-15 5:25 (15 days old)
> First-Bad-Commit: http://git.kernel.org/linus/bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> Message-ID	: <4C677A49.4030904@superonline.com>
> References	: http://marc.info/?l=linux-kernel&m=128184995401968&w=2
> 

Dear Rafael Wysocki,

This regression still exists in 2.6.35.4. (I haven't tested 2.6.36-rcX
series.) Kosaki Motohiro has kindly helped me with this issue and found
a fix for the regression. Today I have successfully tested his patch,
but I don't know whether the patch needs to be further refined and tested.

Regards,

M. Vefa Bicakci
