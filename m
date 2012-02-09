Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2BIJxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:53:45 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58918 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2BIJxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:53:43 -0500
MIME-Version: 1.0
X-Originating-IP: [109.64.24.177]
In-Reply-To: <20120209001335.49f2360b.akpm@linux-foundation.org>
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
	<1328449722-15959-3-git-send-email-gilad@benyossef.com>
	<op.v9csppvv3l0zgt@mpn-glaptop>
	<20120208160344.88d187e5.akpm@linux-foundation.org>
	<CAOtvUMebLNtMcrxuxRq_U5UbwNt-9mE0-0z7Zg79abRTbHE4MQ@mail.gmail.com>
	<20120209001335.49f2360b.akpm@linux-foundation.org>
Date: Thu, 9 Feb 2012 11:53:42 +0200
Message-ID: <CAOtvUMfTXKE4OOErdaT6x5_CmGaYV+sfCxSVsr7MXOJnNxvV7Q@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] smp: add func to IPI cpus based on parameter func
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 10:13 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 9 Feb 2012 10:08:16 +0200 Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> BTW -  I used a macro since I imitated the rest of the code in smp.h
>> but is there any
>> reason not to use an inline macro here?
>
> If it can be implemented in C then sure, go for it - that's superior in
> numerous ways.
>

OK, I tried that and got into a maze of cyclic include files and
function definitions so
I guess I now know why the original code used macros. I guess I'll
leave it as such
for now.

Thanks,
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
