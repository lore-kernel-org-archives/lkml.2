Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab0EDWTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:19:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17338 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab0EDWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:19:06 -0400
Message-ID: <4BE09D4A.6040808@oracle.com>
Date: Tue, 04 May 2010 15:18:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [Bug #15729] BUG: physmap modprobe & rmmod
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera> <8VO9AsMlpMD.A.-m.4IJ4LB@chimera>
In-Reply-To: <8VO9AsMlpMD.A.-m.4IJ4LB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BE09D54.012F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/10 14:21, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
> Subject		: BUG: physmap modprobe & rmmod
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2010-04-02 20:40 (33 days old)
> Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
> References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
> Handled-By	: Hartley Sweeten <hsweeten@visionengravers.com>
> Patch		: https://patchwork.kernel.org/patch/90497/

Yes, leave it as open until the patch is merged, please.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
