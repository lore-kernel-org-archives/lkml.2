Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1H1VTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 17:19:23 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:30374 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1H1VTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 17:19:19 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Aug 2011 17:19:18 EDT
X-ME-engine: default
Message-ID: <4E5AAEFB.2020703@free.fr>
Date: Sun, 28 Aug 2011 23:11:23 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #41262] Terracted T5 does no more work
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera> <gUVi6eNP8RE.A.xHG.WepWOB@chimera>
In-Reply-To: <gUVi6eNP8RE.A.xHG.WepWOB@chimera>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/2011 21:01, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).

I think this bug and bug 41232 in the regression list are identical: 
they both use the same dibcom chipsets. At least proposed patches are 
identical.

Eyes Tv diversity needs this patches too.

--eric


