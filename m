Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636Ab0HFTPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:15:00 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:56984 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427Ab0HFTOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:14:51 -0400
Message-ID: <4C5C5F26.7000905@mandriva.org>
Date: Fri, 06 Aug 2010 22:14:46 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Mandriva/3.1.2-1mdv2011.0 (2011.0) Thunderbird/3.1.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/38] 2.6.35.1-stable review
References: <20100806183250.GA23019@kroah.com>
In-Reply-To: <20100806183250.GA23019@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

06.08.2010 21:32, Greg KH skrev:
> This is the start of the stable review cycle for the 2.6.35.1 release.
> There are 38 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> Responses should be made by August 8, 2010, 18:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.1-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


I think this one should be added as soon as possible too:


> Gitweb:     http://git.kernel.org/linus/396e894d289d69bacf5acd983c97cd6e21a14c08
> Commit:     396e894d289d69bacf5acd983c97cd6e21a14c08
> Parent:     f469461df6ff822f71b8737bda86eea20f16ff93
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri Jul 9 15:12:27 2010 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat Jul 17 12:05:44 2010 +0200
>
>     sched: Revert nohz_ratelimit() for now
>
>     Norbert reported that nohz_ratelimit() causes his laptop to burn about
>     4W (40%) extra. For now back out the change and see if we can adjust
>     the power management code to make better decisions.
>
>     Reported-by: Norbert Preining <preining@logic.at>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Acked-by: Mike Galbraith <efault@gmx.de>
>     Cc: Arjan van de Ven <arjan@infradead.org>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

--
Thomas
