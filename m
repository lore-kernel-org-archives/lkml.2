Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0GHVyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:54:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621Ab0GHVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:54:00 -0400
Date: Thu, 8 Jul 2010 14:53:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Message-Id: <20100708145300.d36cf006.akpm@linux-foundation.org>
In-Reply-To: <20100708213927.GB2934@redhat.com>
References: <201007011744.19564.trenn@suse.de>
	<20100701162601.GC2829@redhat.com>
	<201007021856.00139.trenn@suse.de>
	<20100708213927.GB2934@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 17:39:28 -0400
Jason Baron <jbaron@redhat.com> wrote:

> Make sure we properly call ddebug_remove_module() when a module fails to
> load. In addition, pass the pointer to the "debug table", to both
> ddebug_add_module(), and ddebug_remove_module() so that we can uniquely
> identify each set of debug statements. In this way even modules with the
> same name can be properly identified and removed.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

It'd be nice to track the Reported-by:s.  And the Tested-by:s if/when
they arrive.  SighIllDoIt.

The patch (almost) applies to 2.6.34.  So are we missing a Cc:stable tag
as well?

Also, this patch's title is now "Re: Dynamic Debug broken on
2.6.35-rc3?" which isn't very good.  I can invent a new title for it,
but that means we don't have a well-understood handle to refer to this
patch, and to perform searches with, etc.

Maybe a resend would be best..
