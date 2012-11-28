Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab2K1OFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:05:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62985 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2K1OFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:05:06 -0500
Message-ID: <50B61A0B.5080006@suse.cz>
Date: Wed, 28 Nov 2012 15:04:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zdenek Kabelac <zkabelac@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thorsten Leemhuis <fedora@leemhuis.info>,
        Bruno Wolff III <bruno@wolff.to>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd craziness in 3.7
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org> <CA+55aFywygqWUBNWtZYa+vk8G0cpURZbFdC7+tOzyWk6tLi=WA@mail.gmail.com> <50B6131E.2020805@redhat.com>
In-Reply-To: <50B6131E.2020805@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 02:35 PM, Zdenek Kabelac wrote:
> and added slightly modified patch from Jiri
> (https://lkml.org/lkml/2012/11/15/950
> (Unsure where it still applies for -rc7??)

It is needed for -next only. And if you have recent -next, it's already
there...

thanks,
-- 
js
suse labs
