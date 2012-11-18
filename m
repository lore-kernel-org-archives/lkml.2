Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2KRTIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:08:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53523 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2KRTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:08:02 -0500
Message-ID: <50A9320D.4060700@suse.cz>
Date: Sun, 18 Nov 2012 20:07:57 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zdenek Kabelac <zkabelac@redhat.com>
CC: Mel Gorman <mgorman@suse.de>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>, Valdis.Kletnieks@vt.edu,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: kswapd0: excessive CPU usage
References: <20121015110937.GE29125@suse.de> <5093A3F4.8090108@redhat.com> <5093A631.5020209@suse.cz> <509422C3.1000803@suse.cz> <509C84ED.8090605@linux.vnet.ibm.com> <509CB9D1.6060704@redhat.com> <20121109090635.GG8218@suse.de> <509F6C2A.9060502@redhat.com> <20121112121956.GT8218@suse.de> <50A0F5F0.6090400@redhat.com> <20121112133139.GU8218@suse.de> <50A9304E.3020205@redhat.com>
In-Reply-To: <50A9304E.3020205@redhat.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 08:00 PM, Zdenek Kabelac wrote:
> For some reason my machine went ouf of memory and OOM killed
> firefox and then even whole Xsession.
> 
> Unsure whether it's related to those 2 patches - but I've never had
> such OOM failure before.

As I wrote, this would be me:
https://lkml.org/lkml/2012/11/15/150

There is no -next tree for Friday which would contain the set already.
So for now, it should be enough for you to apply:
https://lkml.org/lkml/2012/11/15/95

Or, alternatively, if you use a brand new systemd, it likes to fork bomb
using udev.

thanks,
-- 
js
suse labs
