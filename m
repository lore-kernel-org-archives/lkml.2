Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0DNMXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:23:30 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:48995 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0DNMX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wBlZCrj4YyPnsHaPX/eEoXnALuBjGyXMqUE0/XOJDgRTf3Tf4bogl7tmVRykE8iTvw
         kEBCoIYd1Yjz1oVvUxSQSzgq85F9fczAygIq+UOPI1sxJVnvXEyUXag5zZCkbW8lHZ45
         a5GoEDKJXaqkOlh4D7ZP6hqaK/UbNU7Hp2RUg=
MIME-Version: 1.0
In-Reply-To: <20100414091825.0bacfe48.kamezawa.hiroyu@jp.fujitsu.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>
	 <20100414091825.0bacfe48.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 14 Apr 2010 15:23:27 +0300
X-Google-Sender-Auth: 268da18b8d3204fc
Message-ID: <s2x84144f021004140523t3092f6cbge410ab4e15afac3e@mail.gmail.com>
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 3:18 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 14 Apr 2010 00:25:00 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> alloc_slab_page never calls alloc_pages_node with -1.
>> It means node's validity check is unnecessary.
>> So we can use alloc_pages_exact_node instead of alloc_pages_node.
>> It could avoid comparison and branch as 6484eb3e2a81807722 tried.
>>
>> Cc: Christoph Lameter <cl@linux-foundation.org>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Minchan, care to send a v2 with proper changelog and reviewed-by attributions?
