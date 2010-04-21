Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0DURTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0DURTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:19:17 -0400
Message-ID: <4BCF336B.1050706@redhat.com>
Date: Wed, 21 Apr 2010 13:18:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Hedi Berriche <hedi@sgi.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com>
In-Reply-To: <20100421165934.GN16427@zorg.emea.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 12:59 PM, Hedi Berriche wrote:
> On Wed, Apr 21, 2010 at 10:20 Alan Cox wrote:
> |>  of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
> |>  started before the login prompt.  It's estimated that with 2048 CPU's we will pass
> |
> | Is that perhaps the bug not the 32K limit?
>
> Doubt it: I just checked on an *idle* 1664 CPUs system and I can see 26844
> tasks, all but few being kernel threads.

That is 15 kernel threads per CPU.

Reducing the number of kernel threads sounds like a
useful thing to do.
