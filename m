Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768Ab2CNKml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:42:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64769 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2CNKmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:42:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203131345290.27008@chino.kir.corp.google.com>
References: <1331652803-3092-1-git-send-email-consul.kautuk@gmail.com>
	<alpine.DEB.2.00.1203131345290.27008@chino.kir.corp.google.com>
Date: Wed, 14 Mar 2012 16:12:39 +0530
Message-ID: <CAFPAmTSUuWW1gc5U=CB1MEoWqEWoDoAkay0svv--qF4n3cOcdg@mail.gmail.com>
Subject: Re: [PATCH 2/2] page_alloc: Remove argument to find_zone_movable_pfns_for_nodes
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 2:17 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 13 Mar 2012, Kautuk Consul wrote:
>
>> The find_zone_movable_pfns_for_nodes() function does not utiilize
>> the argument to it.
>>
>
> It could, though, if we made it to do so.
>
>> Removing this argument from the function prototype as well as its
>> caller, i.e. free_area_init_nodes().
>>
>
> Not sure if we'd ever want it or not for other purposes, but
> find_zone_movable_pfns_for_nodes() could easily be made to use the passed
> in array rather than zone_movable_pfn in file scope directly.  That seems
> to be why it took an argument in the first place.
>

No function is calling this function and I just wanted to remove the
slight overhead of passing an
argument which does not get used.
