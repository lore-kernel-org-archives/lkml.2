Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2FOHg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:36:59 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:41164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2FOHg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:36:57 -0400
Message-ID: <1339745811.4512.0.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH wireless-next 00/20] Use pr_<level>
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        libertas-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 09:36:51 +0200
In-Reply-To: <cover.1339739415.git.joe@perches.com> (sfid-20120615_080311_586023_85E50A2D)
References: <cover.1339739415.git.joe@perches.com>
	 (sfid-20120615_080311_586023_85E50A2D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 22:53 -0700, Joe Perches wrote:
> Update logging style

So ... since we make everybody else explain *why* they make a change, I
think you should too. I don't see a reason for this random patching of
perfectly good code.

johannes

