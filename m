Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab2KQHKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 02:10:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56157 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2KQHKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 02:10:43 -0500
Date: Sat, 17 Nov 2012 11:10:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
Message-ID: <20121117071039.GA22855@moon>
References: <20121114151937.344922058@openvz.org>
 <20121114152239.936025193@openvz.org>
 <20121116155603.2118394c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116155603.2118394c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 03:56:03PM -0800, Andrew Morton wrote:
> 
> This is a lousy output format.  It's sort-of like a sensible set of
> name-value tuples: "name:value name:value name:value" but
> 
> a) it has lots of random pointless whitespace after the colons and
> 
> b) several of the labels have spaces in them, just to make life
>    harder for parsing code and
> 
> c) inotify-wd is secretly printed in decimal while everything else
>    is in hex.
> 
> What happens if we do something like the below (which will require a
> changelog update)?

Looks good for me, Andrew. The only reason for such whitespace rich format
was to make output column aligned. But it's fine to have name:val as well.
I'll update. Thanks!

	Cyrill
