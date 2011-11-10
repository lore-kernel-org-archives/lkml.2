Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab1KJGFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:05:00 -0500
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:57682 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776Ab1KJGE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:04:59 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 01:04:58 EST
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=2.0 cv=LI3kseq9 c=1 sm=0 a=r17jK6sfZkYSxad0qIwqKg==:17 a=4u2ML38iGB4A:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=1X9xUbg-ZKARFjA3trUA:9 a=CjuIK1q_8ugA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Joakim Tjernlund'" <Joakim.Tjernlund@transmode.se>
Cc: <linux-kernel@vger.kernel.org>,
        "'Frank Zago'" <fzago@systemfabricworks.com>
References: <1320312505-30612-1-git-send-email-Joakim.Tjernlund@transmode.se> <20111109161539.b2cdf381.akpm@linux-foundation.org>
In-Reply-To: <20111109161539.b2cdf381.akpm@linux-foundation.org>
Subject: RE: [PATCH] crc32: Optimize inner loop.
Date: Wed, 9 Nov 2011 23:58:35 -0600
Message-ID: <049d01cc9f6d$c962f8a0$5c28e9e0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIYnQyKk9Dyekf38u8yNbxG55wgSwF8soF1lQG2UgA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I meant to ask about that.  The discussion was fairly long and complex
> and I'm now unsure whether the patch I have is a still up-to-date,
> whether it is a good one, whether it has additional testing results,
> etc.

The original patch that went into your mm tree was replaced by a cleaner one
over time but the review process went on and on and I had to spend more time
with my day job. Eventually I just couldn't figure out how to get everyone
any happier. I was really reluctant to give up performance on the Intel
platform
but we were mostly arguing about 2-3% give or take.

It seems that the folks that wanted the same algorithm for crc32c may have
figured out how to reach a compromise.


