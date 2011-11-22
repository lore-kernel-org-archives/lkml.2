Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1KVKGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:06:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44068 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1KVKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:06:12 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1111150951140.22502@router.home>
References: <1321179449-6675-1-git-send-email-gilad@benyossef.com>
	<1321179449-6675-2-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1111150951140.22502@router.home>
Date: Tue, 22 Nov 2011 12:06:11 +0200
Message-ID: <CAOtvUMcbMTSRhmc5N=jTVN2LMowoz3Wy5kdy9e1Y07LtV6bSUg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] smp: Introduce a generic on_each_cpu_mask function
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 5:51 PM, Christoph Lameter <cl@linux.com> wrote:
> On Sun, 13 Nov 2011, Gilad Ben-Yossef wrote:
>
>> on_each_cpu_mask calls a function on processors specified my cpumask,
>> which may include the local processor.
>
> Reviewed-by: Christoph Lameter <cl@linux.com>
>

Thanks :-)

v4 is on the way.

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
