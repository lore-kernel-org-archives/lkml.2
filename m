Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0KERsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0KERs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:48:27 -0400
Date: Fri, 5 Nov 2010 18:41:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Roland McGrath <roland@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        JANAK DESAI <janak@us.ibm.com>
Subject: [PATCH 0/1] (Was: oom: fix oom_score_adj consistency with
	oom_disable_count)
Message-ID: <20101105174142.GA19469@redhat.com>
References: <201010262121.o9QLLNFo016375@imap1.linux-foundation.org> <20101101024949.6074.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011011738200.26266@chino.kir.corp.google.com> <alpine.DEB.2.00.1011021741520.21871@chino.kir.corp.google.com> <20101103112324.GA29695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103112324.GA29695@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03, Oleg Nesterov wrote:
>
> However. Please do not touch this code. It doesn't work anyway,
> I'll resend the patch which removes this crap.

This code continues to confuse developers. And this is the only
effect it has.

Once again. The patch removes the DEAD code. It is never called,
it can't work (from 2006) but this is not immediately clear.
Howver it often needs attention/changes because it _looks_ as if
it works.

Let's remove it, finally.

Oleg.

