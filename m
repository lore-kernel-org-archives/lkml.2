Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1KUNqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:46:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1KUNqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:46:15 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VrcpeX3YRb0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=8B0y74AbsREmsCCZHrwA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [patch] mm: memcg: shorten preempt-disabled section around
 event checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Yong Zhang <yong.zhang0@gmail.com>,
        Luis Henriques <henrix@camandro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20111121110954.GE1771@redhat.com>
References: <20111121110954.GE1771@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 08:46:07 -0500
Message-ID: <1321883167.20742.4.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 12:09 +0100, Johannes Weiner wrote:
> -rt ran into a problem with the soft limit spinlock inside the
> non-preemptible section, because that is sleeping inside an atomic
> context.  But I think it makes sense for vanilla, too, to keep the
> non-preemptible section as short as possible.  Also, -3 lines.
> 

Johannes,

Thanks for this patch. It is very much appreciated by us -rt folks :)

-- Steve


