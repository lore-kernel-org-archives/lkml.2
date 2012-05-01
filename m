Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2EAL0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:26:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58769 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2EAL0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:26:49 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120501001238.GA15497@bloggs.ozlabs.ibm.com>
References: <20120501001238.GA15497@bloggs.ozlabs.ibm.com>
Date: Tue, 1 May 2012 14:26:48 +0300
Message-ID: <CAOtvUMfgAGBXx-nvFbMHywYGLmKfmbpcQajddoGYA+B22vLOiw@mail.gmail.com>
Subject: Re: get/put_online_cpus documentation wrong?
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 3:12 AM, Paul Mackerras <paulus@samba.org> wrote:
>
> In Documentation/cpu-hotplug.txt it says:
>
> "       #include <linux/cpu.h>
>        get_online_cpus() and put_online_cpus():
>
> The above calls are used to inhibit cpu hotplug operations. While the
> cpu_hotplug.refcount is non zero, the cpu_online_mask will not change.
> If you merely need to avoid cpus going away, you could also use
> preempt_disable() and preempt_enable() for those sections.
> Just remember the critical section cannot call any
> function that can sleep or schedule this process away."


I *think* the critical section remark here is referring to using
preempt_disable/enable(),
rather  then the use of get/put_online_cpus().

Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
