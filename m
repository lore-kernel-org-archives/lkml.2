Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1INShb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:37:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab1INSh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:37:28 -0400
Date: Wed, 14 Sep 2011 20:33:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCHSET cgroup] extend threadgroup locking
Message-ID: <20110914183354.GA16922@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <20110911033536.GO29319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911033536.GO29319@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 09/11, Tejun Heo wrote:
>
> Oleg, this one definitely needs your review.  The original thread is...
>
>   http://thread.gmane.org/gmane.linux.kernel/1187853/focus=1188347

OK, I'll try to read it this week when I get recovered, I am ill now.

But I got lost... What about

	http://thread.gmane.org/gmane.linux.kernel/1184375

which I didn't read yet? It seems that they conflict with each other.

Should I ignore the series above? Probably yes, it surely conflicts
with the task-counter patches in -mm.

Oleg.

