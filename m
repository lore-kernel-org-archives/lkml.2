Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0KSCoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:44:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60714 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0KSCn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:43:59 -0500
Message-ID: <4CE5E3EE.1080104@cn.fujitsu.com>
Date: Fri, 19 Nov 2010 10:41:50 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #23092] WARNING in tty_io.c
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera> <ATV3yiK8i4C.A.O7C.ehb5MB@chimera>
In-Reply-To: <ATV3yiK8i4C.A.O7C.ehb5MB@chimera>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-19 10:44:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-19 10:44:18,
	Serialize complete at 2010-11-19 10:44:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote, at 11/19/2010 07:42 AM:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23092
> Subject		: WARNING in tty_io.c
> Submitter	: Shan Wei <shanwei@cn.fujitsu.com>
> Date		: 2010-11-10 8:06 (9 days old)
> Message-ID	: <4CDA5291.4010802@cn.fujitsu.com>
> References	: http://marc.info/?l=linux-kernel&m=128937645120159&w=2

It's not appreared in 2.6.37-rc2+ with top commit 59365d13.
I don't know which patch/commit fix it.

-- 
Best Regards
-----
Shan Wei
