Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1GJRDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 13:03:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48724 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755897Ab1GJRDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 13:03:41 -0400
X-Authenticated: #12510340
X-Provags-ID: V01U2FsdGVkX1+tr/gZht6tf4s3UP/N0f0ozBVyz6KtVUwbxyl5+A
	x5HKHxkEeE8SjA
Message-ID: <4E19DB69.5020406@gmx.net>
Date: Sun, 10 Jul 2011 19:03:37 +0200
From: Olaf Freyer <aaron667@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110705 Thunderbird/5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #36182] Erroneous package power limit notification since
 kernel 2.6.39
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.Sh.gmYGOB@chimera>
In-Reply-To: <gK_efVqs2fP.A.Sh.gmYGOB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue is still worth listing, as it isn't resolved yet.

Jesse Barnes already tracked down the cause to commit
ccab5c82759e2ace74b2e84f82d1e0eedd932571 -
but what to do now remains unclear to me.

With the patch reverted, I get down to 1 warning per workday -
without reverting it I'm at 70-90k warnings per workday.


Am 10.07.2011 12:58, schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36182
> Subject		: Erroneous package power limit notification since kernel 2.6.39
> Submitter	: Olaf Freyer <aaron667@gmx.net>
> Date		: 2011-05-22 13:01 (50 days old)
> Message-ID	: <4DD9092A.4080507@gmx.net>
> References	: http://marc.info/?l=linux-kernel&m=130606930631131&w=2
>
>
>

