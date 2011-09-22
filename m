Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1IVXQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:16:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1IVXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:16:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=sK4o04KH+UryXvRl/xodmYJlBlgw/lwV6Wi3DsED9GyPM5/5CKdFJjovfpIdFGl8g
	JXMJCLO3m7MaBajvZbquw==
Date: Thu, 22 Sep 2011 16:15:39 -0700
From: Andrew Morton <akpm@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/8] kstaled: add histogram sampling functionality
Message-Id: <20110922161539.d947e014.akpm@google.com>
In-Reply-To: <1316230753-8693-8-git-send-email-walken@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<1316230753-8693-8-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 20:39:12 -0700
Michel Lespinasse <walken@google.com> wrote:

> add statistics for pages that have been idle for 1,2,5,15,30,60,120 or
> 240 scan intervals into /dev/cgroup/*/memory.idle_page_stats

Why?  What's the use case for this feature?
