Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1BVVF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:05:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35262 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1BVVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:05:54 -0500
Message-ID: <4D6424F4.4050208@oracle.com>
Date: Tue, 22 Feb 2011 13:04:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #22882] (2.6.37-rc1) amd64-agp module crashed on second
 load
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera> <f14qsMvj2tF.A.8BF.ffuYNB@chimera>
In-Reply-To: <f14qsMvj2tF.A.8BF.ffuYNB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D642529.0054:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/11 14:37, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22882
> Subject		: (2.6.37-rc1) amd64-agp module crashed on second load
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2010-11-05 0:13 (109 days old)
> Message-ID	: <20101104171333.fea1f498.randy.dunlap@oracle.com>
> References	: http://marc.info/?l=linux-kernel&m=128891605213447&w=2
> Handled-By	: Florian Mickler <florian@mickler.org>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=46682

  ^^^^^ this patch just needs to be merged into mainline.

thanks.  [resend due to multiple email failures (last attempt)]
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
