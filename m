Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab1FQDgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:36:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47489 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab1FQDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:36:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFACB8A.2020008@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 12:35:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: hch@infradead.org
CC: david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/12] Per superblock cache reclaim
References: <1306998067-27659-1-git-send-email-david@fromorbit.com> <20110616113321.GA22422@infradead.org>
In-Reply-To: <20110616113321.GA22422@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/16 20:33), Christoph Hellwig wrote:
> Can we get some comments from the MM folks for patches 1-3?  Those look
> like some pretty urgent fixes for really dumb shrinker behaviour.

Yeah, I'm reviewing today. I'm sorry delayed it. So, generically they are
pretty good to me. thanks Dave. So, I have a few minor comments and I'll post
it when my review is finished. (Maybe some hour later).


