Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2EFNQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:16:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50370 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2EFNQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:16:38 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4FA36045.9080504@linux.vnet.ibm.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-4-git-send-email-gilad@benyossef.com>
	<4FA36045.9080504@linux.vnet.ibm.com>
Date: Sun, 6 May 2012 16:16:37 +0300
Message-ID: <CAOtvUMegjdS_Oz40QaziLrkezCGThqx=RMMY-cuyuEU-GQAQUw@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] workqueue: introduce schedule_on_each_cpu_cond
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 7:51 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 05/03/2012 08:25 PM, Gilad Ben-Yossef wrote:
>

>>  /**
>> + * schedule_on_each_cpu_cond - execute a function synchronously on each
>> + * online CPU for which the supplied condition function returns true
>> + * @func: the function to run on the selected CPUs
>> + * @cond_func: the function to call to select the CPUs
>> + *
>> + * schedule_on_each_cpu_cond() executes @func on each online CPU for
>> + * @cond_func returns true using the system workqueue and blocks until
>
>    ^^^
> (for) which

Thanks!

I'll fix this and the other typo in the next iteration.

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
