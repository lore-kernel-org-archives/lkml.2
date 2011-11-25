Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1KYCex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 21:34:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42588 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1KYCev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 21:34:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Nov 2011 11:33:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/4] Change cpustat fields to an array.
Message-Id: <20111125113345.baa455e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322184806-20421-2-git-send-email-glommer@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com>
	<1322184806-20421-2-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011 23:33:23 -0200
Glauber Costa <glommer@parallels.com> wrote:

> This patch changes fields in cpustat from a structure, to an
> u64 array. Math gets easier, and the code is more flexible.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Paul Tuner <pjt@google.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>

I like this change.
Reivewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

