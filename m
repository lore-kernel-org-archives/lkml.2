Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1KJVub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:50:31 -0500
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:64717 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1KJVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:50:28 -0500
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=2.0 cv=LI3kseq9 c=1 sm=0 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=4u2ML38iGB4A:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=zokvVckg0wu4hiL5sesA:9 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Frank Zago'" <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <1320312505-30612-1-git-send-email-Joakim.Tjernlund@transmode.se> <20111109161539.b2cdf381.akpm@linux-foundation.org> <049d01cc9f6d$c962f8a0$5c28e9e0$@systemfabricworks.com> <OF379E7B25.DD8B41D5-ONC1257944.002E2296-C1257944.002E8AB3@transmode.se>
In-Reply-To: <OF379E7B25.DD8B41D5-ONC1257944.002E2296-C1257944.002E8AB3@transmode.se>
Subject: RE: [PATCH] crc32: Optimize inner loop.
Date: Thu, 10 Nov 2011 15:50:25 -0600
Message-ID: <00ae01cc9ff2$c2106c60$46314520$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIYnQyKk9Dyekf38u8yNbxG55wgSwF8soF1AftN5g8BY4DYkpTnzr5Q
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> crc32c are based on your patches and can't move on until your work
> is applied.
> 
Ahhhh. I've been heads down for a month on Portals4 over InfiniBand for
Sandia and
haven't been paying much attention. Please let me know what I can do to help
unstick
things. I want to help.
>  Jocke

