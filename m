Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab2JKW0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:26:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48631 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2JKW0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:26:04 -0400
Message-ID: <50774779.8000005@suse.cz>
Date: Fri, 12 Oct 2012 00:26:01 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kswapd0: wxcessive CPU usage
References: <507688CC.9000104@suse.cz> <20121011151413.3ab58542.akpm@linux-foundation.org>
In-Reply-To: <20121011151413.3ab58542.akpm@linux-foundation.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 12:14 AM, Andrew Morton wrote:
> Could you please do a sysrq-T a few times while it's spinning, to
> confirm that this trace is consistently the culprit?

For me yes, shrink_slab is in the most of the traces.

-- 
js
suse labs
