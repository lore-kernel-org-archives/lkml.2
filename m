Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2KGH6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:58:47 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58573 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2KGH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <509A1438.7020008@linux.vnet.ibm.com>
References: <CAKohpomr6wkNNi3tt=obzM=2atZfRLQ0V4XOzX__W1yB8UKgTg@mail.gmail.com>
	<509A1438.7020008@linux.vnet.ibm.com>
Date: Wed, 7 Nov 2012 13:28:46 +0530
Message-ID: <CAKohpo=w1ykm7Yu=LvDyA9GdyJ9CzyY73omBi4pcZD_m8F30vg@mail.gmail.com>
Subject: Re: [Query]: sched/fair: prio_changed_fair()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        PDSW-power-team <pdsw-power-team@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2012 13:26, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> It's the user nice value I suppose, so it should be reversed when we are
> talking about weight.

Ahh.. I knew it .. How can i miss it.

Sorry for the noise :(

--
viresh
