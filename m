Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1FUF1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 01:27:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41197 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1FUF1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 01:27:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E002BD0.3000003@jp.fujitsu.com>
Date: Tue, 21 Jun 2011 14:27:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: david@fromorbit.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 03/12] vmscan: reduce wind up shrinker->nr when shrinker
 can't do work
References: <1306998067-27659-1-git-send-email-david@fromorbit.com> <1306998067-27659-4-git-send-email-david@fromorbit.com> <4DFE997C.2060805@jp.fujitsu.com> <20110621050914.GO32466@dastard>
In-Reply-To: <20110621050914.GO32466@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I mean, currently some mm folks plan to enhance shrinker. So,
>> sharing benchmark may help to avoid an accidental regression.
> 
> I predict that I will have some bug reporting to do in future. ;)

Ok, I have no objection. thanks.


