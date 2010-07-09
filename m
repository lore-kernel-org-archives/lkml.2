Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0GIX6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab0GIX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:58:48 -0400
Date: Fri, 9 Jul 2010 16:57:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, hare@suse.de,
       stable@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: Dynamic Debug lib: Fix memory corruption for specific module
 declarations
Message-Id: <20100709165752.0daac206.akpm@linux-foundation.org>
In-Reply-To: <201007091310.43314.trenn@suse.de>
References: <201007091310.43314.trenn@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 13:10:42 +0200
Thomas Renninger <trenn@suse.de> wrote:

> From: Jason Baron <jbaron@redhat.com>

You forgot to cc Jason.

> Make sure we properly call ddebug_remove_module() when a module fails to
> load. In addition, pass the pointer to the "debug table", to both
> ddebug_add_module(), and ddebug_remove_module() so that we can uniquely
> identify each set of debug statements. In this way even modules with the
> same name can be properly identified and removed.
> 
> Kernel bug reference:
> http://bugzilla.kernel.org/show_bug.cgi?id=16330
> 
> By trenn (for stable people):
> Not sure for how long this bug exists (always?), it nearly patches
> fine for a 2.6.32 kernel...

It's unclear what kernel this is against.  It applies quite badly to
mainline.  I fixed all that up then lost the result :( It doesn't apply
cleanly to 2.6.34 either.

I was going to steal your changelog and add it to Jason's patch but
Jason's patch generates a reject storm against mainline too.

Giving up.

