Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1FTEaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:30:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35940 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1FTEai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:30:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFECCE5.5030409@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 13:30:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: david@fromorbit.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 02/12] vmscan: shrinker->nr updates race and go wrong
References: <1306998067-27659-1-git-send-email-david@fromorbit.com> <1306998067-27659-3-git-send-email-david@fromorbit.com> <4DFE987E.1070900@jp.fujitsu.com> <20110620012531.GN561@dastard>
In-Reply-To: <20110620012531.GN561@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Looks great fix. Please remove tracepoint change from this patch and send it
>> to -stable. iow, I expect I'll ack your next spin.
> 
> I don't believe such a change belongs in -stable. This code has been
> buggy for many years and as I mentioned it actually makes existing
> bad shrinker behaviour worse. I don't test stable kernels, so I've
> got no idea what side effects it will have outside of this series.
> I'm extremely hesitant to change VM behaviour in stable kernels
> without having tested first, so I'm not going to push it for stable
> kernels.

Ok, I have no strong opinion.



> 
> If you want it in stable kernels, then you can always let
> stable@kernel.org know once the commits are in the mainline tree and
> you've tested them...

