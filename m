Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2I0AD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 20:03:59 -0400
Received: from nm10.bullet.mail.bf1.yahoo.com ([98.139.212.169]:42928 "HELO
	nm10.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751167Ab2I0ADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 20:03:54 -0400
X-Yahoo-Newman-Id: 530763.94523.bm@omp1022.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ClGUYAQVM1nnODR_x89IvnvlsGQ8FuMhFetqqPFctE45j4E
 28wA.rAaEF8M2u9f4505ZK4ayJzuxTIuoEo6n5nUTBPKxqrM5tkDmwJgu2Dw
 4YAmQ.cyv8ob6OTF1S_X7mb8vm83t7ul8vH8.h48SwsvsrgaLo2ZYvD6Bvgc
 hTSTf2r.n0mfWbfU0K32VAHmbHP406QzfFTVRBAb0JIgRjjlDHfa1vTOgHIt
 uRXZZAhlLH9azv9spuEMApH4DRtSkXn297O0jthk35nVQf72eJLpvlj6W1Lf
 2rLzHo.tav5RvbRlEsHkOfsQS97a8NWVIqivekksV16Cr.SIaEduLCS2NzjQ
 rFO3svqohPHmvXgoJkeGfp9vQWxNEMUmAzK2aco63.7WolxbKk900bUIQ1fu
 onmWbST1PLV6ZklhSzEycZbBUCfZL7fnlXtCPucyyBu2UmqX58A--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506397E9.1070000@att.net>
Date: Wed, 26 Sep 2012 19:03:53 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        torvalds@linux-foundation.org
Subject: Re: Please be aware that __always_inline doesn't mean "always inline"!
References: <50638DCC.5040506@att.net> <20120926165044.46b8f7d6.akpm@linux-foundation.org>
In-Reply-To: <20120926165044.46b8f7d6.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 06:50 PM, Andrew Morton wrote:
> As I mentioned in the other thread, the __always_inline's in fs/namei.c
> (at least) are doing exactly what we want them to do, so some more
> investigation is needed here?
Yes, definitely. When I did some tests on it (to confirm the behavior) a
few months ago, it did behave as advertised. Sounds like this definitely
needs more research. Thanks Andrew.

Daniel

