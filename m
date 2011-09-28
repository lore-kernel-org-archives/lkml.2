Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1I1EhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:37:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56851 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1I1EhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:37:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 13:36:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wizard <wizarddewhite@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, linux-mm@kvack.org
Subject: Re: [PATCH]   fix find_next_system_ram comments
Message-Id: <20110928133621.45f936df.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317132124-2820-1-git-send-email-wizarddewhite@gmail.com>
References: <1317132124-2820-1-git-send-email-wizarddewhite@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 22:02:04 +0800
Wizard <wizarddewhite@gmail.com> wrote:

> The purpose of find_next_system_ram() is to find a the lowest
> memory resource which contain or overlap the [res->start, res->end),
> not just contain.
> 
> In this patch, I make this comment more exact and fix one typo.
> 
> Signed-off-by: Wei Yang <wizarddewhite@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

