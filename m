Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2LVDnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:43:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2LVDnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:43:49 -0500
Message-ID: <50D52D4B.9040702@redhat.com>
Date: Fri, 21 Dec 2012 22:47:23 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 2/3] x86,smp: proportional backoff for ticket spinlocks
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185115.1858ffc5@annuminas.surriel.com> <20121222030756.GD27621@home.goodmis.org> <20121222031433.GE27621@home.goodmis.org>
In-Reply-To: <20121222031433.GE27621@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 10:14 PM, Steven Rostedt wrote:

> OK, I replied here before reading patch 3 (still reviewing it). Why have
> this patch at all? Just to test if you broke something between this and
> patch 3? Or perhaps patch 3 may not get accepted? In that case, you
> would still need a comment.
>
> Either explicitly state that this patch is just a stepping stone for
> patch 3, and will either be accepted or rejected along with patch 3. Or
> keep it as a stand alone patch and add comments as such. Or just get rid
> of it all together.

I will document this patch better, explaining that it is
a stepping stone, that the number 50 is likely to be
wrong for many systems, and that the next patch fixes
things, using this text in the changelog:



The number 50 is likely to be wrong for many setups, and
this patch is mostly to illustrate the concept of proportional
backup. The next patch automatically tunes the delay value.

