Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1JDBTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:19:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57038 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1JDBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:19:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Oct 2011 10:18:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com
Subject: Re: [PATCH v4 5/8] per-netns ipv4 sysctl_tcp_mem
Message-Id: <20111004101840.442e3c4a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317637123-18306-6-git-send-email-glommer@parallels.com>
References: <1317637123-18306-1-git-send-email-glommer@parallels.com>
	<1317637123-18306-6-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Oct 2011 14:18:40 +0400
Glauber Costa <glommer@parallels.com> wrote:

> This patch allows each namespace to independently set up
> its levels for tcp memory pressure thresholds. This patch
> alone does not buy much: we need to make this values
> per group of process somehow. This is achieved in the
> patches that follows in this patchset.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

