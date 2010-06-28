Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0F1Eyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 00:54:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42773 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0F1Eyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 00:54:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Jun 2010 13:50:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Narendra Prasad Madanapalli <narendramind@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Better resource control
Message-Id: <20100628135011.8215abb0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTil2BgJjiNTKJD1q3nDtaKVgGtaTLEK1TD3sD2LF@mail.gmail.com>
References: <AANLkTil2BgJjiNTKJD1q3nDtaKVgGtaTLEK1TD3sD2LF@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 22:09:56 +0530
Narendra Prasad Madanapalli <narendramind@gmail.com> wrote:

> Hi All,
> 
> There is problem, Resource Control, listed as one of large projects in
> kernelnewbies.org
> (http://kernelnewbies.org/KernelProjects/ResourceControl).
> 
> I would like to start working on the problem. I understand from the
> link that CPU schedulers are to be improved based on statistical data.
> 
> I appreciate if any one can let me know the status of Resource Control
> in Linux and provide me thought process on where the analysis needs to
> be started.
> 

please read
Documentation/cgroup

and think about what is not implemented, yet.

Thanks,
-Kame

> 
> Thanks,
> Narendra.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

