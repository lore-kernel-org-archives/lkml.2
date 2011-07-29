Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1G2NmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:42:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37178 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1G2NmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110729095005.GH1843@barrios-desktop>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <20110727161821.GA1738@barrios-desktop> <20110728113852.GN3010@suse.de>
 <20110729094816.GG1843@barrios-desktop> <20110729095005.GH1843@barrios-desktop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 29 Jul 2011 09:41:59 -0400
X-Google-Sender-Auth: 13rtFx7ully8yLVuuxw0XjBPgAo
Message-ID: <CAObL_7Fnc820gFvFxZa3iHUzkKaZaMy9o7LAN7z8mk8_zUxkrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 5:50 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Sorry for missing Ccing.
>
> On Fri, Jul 29, 2011 at 06:48:16PM +0900, Minchan Kim wrote:
>> On Thu, Jul 28, 2011 at 12:38:52PM +0100, Mel Gorman wrote:
>> > On Thu, Jul 28, 2011 at 01:18:21AM +0900, Minchan Kim wrote:
>> > > On Thu, Jul 21, 2011 at 05:28:42PM +0100, Mel Gorman wrote:
>> > > > Note how preventing kswapd reclaiming dirty pages pushes up its CPU
>>
>> <snip>
>>
>> > > > usage as it scans more pages but it does not get excessive due to
>> > > > the throttling.
>> > >
>> > > Good to hear.
>> > > The concern of this patchset was early OOM kill with too many scanning.
>> > > I can throw such concern out from now on.
>> > >
>> >
>> > At least, I haven't been able to trigger a premature OOM.
>>
>> AFAIR, Andrew had a premature OOM problem[1] but I couldn't track down at that time.
>> I think this patch series might solve his problem. Although it doesn't, it should not accelerate
>> his problem, at least.
>>
>> Andrew, Could you test this patchset?

Gladly, but not until Wednesday most likely.  I'm defending my thesis
on Monday :)

--Andy
