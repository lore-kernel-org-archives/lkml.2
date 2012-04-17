Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2DQVdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:33:19 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48525 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2DQVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:33:18 -0400
Date: Tue, 17 Apr 2012 14:33:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120417213313.GC19975@google.com>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
 <CAE9FiQXWKzv7Wo4iWGrKapmxQYtAGezghwup1UKoW2ghqUSr+A@mail.gmail.com>
 <20120417173203.GA32482@tiehlicka.suse.cz>
 <CAE9FiQXvZ4eSCwMSG2H7CC6suQe37TmQpmOEKW_082W3zz-6Fw@mail.gmail.com>
 <20120417183042.GA21051@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417183042.GA21051@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sam.

On Tue, Apr 17, 2012 at 08:30:42PM +0200, Sam Ravnborg wrote:
> It would be nice if someone familiar with the memblock/bootmem
> internals could cleans up the leftovers from the migration
> of x86 to memblock / nobootmem.
> 
> This would be less to be confused about when other migrate to
> use memblock.

I can't remember the details now (my memory sucks big time) but there
were some obstacles and I decided to defer cleaning up.  I'm kinda
overwhelmed in other areas so if anyone is interested in cleaning up,
I'll be happy to help.  If not, I'll try to get to it.

Thanks.

-- 
tejun
