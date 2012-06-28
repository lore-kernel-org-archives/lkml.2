Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2F1UTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:19:55 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:40929 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2F1UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:19:54 -0400
X-WSS-ID: 0M6CGH5-0B-0H0-02
X-M-MSG: 
X-Server-Uuid: 6BFC7783-7E22-49B4-B610-66D6BE496C0E
Message-ID: <4FECBC50.2060705@sandia.gov>
Date: Thu, 28 Jun 2012 14:19:28 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120425
 Thunderbird/10.0.4
MIME-Version: 1.0
To: "Rik van Riel" <riel@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm v2] mm: have order > 0 compaction start off
 where it left
References: <20120628135520.0c48b066@annuminas.surriel.com>
In-Reply-To: <20120628135520.0c48b066@annuminas.surriel.com>
X-TMWD-Spam-Summary: TS=20120628201929; ID=1; SEV=2.3.1;
 DFV=B2012062820; IFV=NA; AIF=B2012062820; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230342E34464543424335312E303032463A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2012062820_5.03.0010
X-WSS-ID: 63F263DA0QW5466003-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 11:55 AM, Rik van Riel wrote:

> ---
> v2: implement Mel's suggestions, handling wrap-around etc
>

So far I've run a total of ~28 TB of data over seventy minutes
or so through 12 machines running this version of the patch;
still no hint of trouble, still great performance.

Tested-by: Jim Schutt <jaschut@sandia.gov>

Thanks!

-- Jim

