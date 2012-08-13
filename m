Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2HMUgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:36:31 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:41635 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2HMUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:36:28 -0400
X-WSS-ID: 0M8PNWQ-0B-3KP-02
X-M-MSG: 
X-Server-Uuid: 6BFC7783-7E22-49B4-B610-66D6BE496C0E
Message-ID: <50296522.2000809@sandia.gov>
Date: Mon, 13 Aug 2012 14:35:46 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607
 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Mel Gorman" <mgorman@suse.de>
cc: Linux-MM <linux-mm@kvack.org>, "Rik van Riel" <riel@redhat.com>,
        "Minchan Kim" <minchan@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Improve hugepage allocation success rates
 under load V3
References: <1344520165-24419-1-git-send-email-mgorman@suse.de>
 <5023FE83.4090200@sandia.gov> <20120809204630.GJ12690@suse.de>
 <50243BE0.9060007@sandia.gov> <20120810110225.GO12690@suse.de>
 <502542C7.8050306@sandia.gov> <20120812202257.GA4177@suse.de>
In-Reply-To: <20120812202257.GA4177@suse.de>
X-TMWD-Spam-Summary: TS=20120813203559; ID=1; SEV=2.3.1;
 DFV=B2012081323; IFV=NA; AIF=B2012081323; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230362E35303239363532462E303031383A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2012081323_5.03.0010
X-WSS-ID: 7C37BAA74N0922498-01-01
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

Hi Mel,

On 08/12/2012 02:22 PM, Mel Gorman wrote:

>
> I went through the patch again but only found the following which is a
> weak candidate. Still, can you retest with the following patch on top and
> CONFIG_PROVE_LOCKING set please?
>

I've gotten in several hours of testing on this patch with
no issues at all, and no output from CONFIG_PROVE_LOCKING
(I'm assuming it would show up on a serial console).  So,
it seems to me this patch has done the trick.

CPU utilization is staying under control, and write-out rate
is good.

You can add my Tested-by: as you see fit.  If you work
up any refinements and would like me to test, please
let me know.

Thanks -- Jim

