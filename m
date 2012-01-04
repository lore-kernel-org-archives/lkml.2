Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2ADUSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:18:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab2ADUSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:18:52 -0500
Message-ID: <4F04B3F0.6080103@redhat.com>
Date: Wed, 04 Jan 2012 15:17:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, penberg@kernel.org,
        aarcange@redhat.com, mel@csn.ul.ie, rientjes@google.com,
        dima@android.com, rebecca@android.com, san@google.com,
        akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com,
        Minchan Kim <minchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related
 changes in MM
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com> <20120104195612.GB19181@suse.de>
In-Reply-To: <20120104195612.GB19181@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 02:56 PM, Greg KH wrote:

> How does this compare with the lowmemorykiller.c driver from the android
> developers that is currently in the linux-next tree?

Also, the low memory notification that Kosaki-san has worked on,
and which Minchan is looking at now.

We seem to have many mechanisms under development, all aimed at
similar goals. I believe it would be good to agree on one mechanism
that could solve multiple of these goals at once, instead of sticking
a handful of different partial solutions in the kernel...

Exactly what is the problem you are trying to solve?

-- 
All rights reversed
