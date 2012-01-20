Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2ATXag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:30:36 -0500
Received: from que11.charter.net ([209.225.8.21]:50059 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2ATXac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:30:32 -0500
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 18:30:31 EST
X-Authority-Analysis: v=1.1 cv=JYQIUidRAECiNa+jsiaNMIhYElg3H2WoMKCJIGO75f4=
 c=1 sm=1 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=ENlZekBbApn4pOrszY0A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: Brice.Goglin@inria.fr, julia.lawall@lip6.fr, mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: Re: coccicheck in 3.3rc1 
Date: Fri, 20 Jan 2012 17:10:34 -0600
Message-Id: <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4F1928FC.8090300@inria.fr>
References: <4F1928FC.8090300@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/2012 2:42 AM, Brice Goglin wrote:
>I see that reverting d0bc1fb4 makes "make coccicheck M=..." ignore
> "M=..." so now I understand the aim of this commit now. I can certainly
> switch away from "make C=2 CHECK=scripts/coccicheck M=..." to "make
> coccicheck M=...". But I'd like away to get the very basic output back:

Hi Brice,
Sorry for the trouble. Can you try the patch I've created and see
if it works properly when you use "make C=2 CHECK=scripts/coccicheck M=..." ?
The patch puts the handling back the way it was for the C=1 and C=2
use case.

Also, I've added the LKML Mailing List to the cc so that this
patch is posted publicly.

Greg Dietsche (1):
  coccicheck: change handling of C={1,2} when M= is set

 scripts/coccicheck |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

-- 
1.7.6.4

