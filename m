Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1HWJWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:22:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54110 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1HWJWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:22:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 23 Aug 2011 18:15:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom: skip frozen tasks
Message-Id: <20110823181505.f7dd43ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110823073101.6426.77745.stgit@zurg>
References: <20110823073101.6426.77745.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 11:31:01 +0300
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> All frozen tasks are unkillable, and if one of them has TIF_MEMDIE
> we must kill something else to avoid deadlock. After this patch
> select_bad_process() will skip frozen task before checking TIF_MEMDIE.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


