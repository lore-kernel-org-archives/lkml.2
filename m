Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0DFX0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:26:44 -0400
Received: from tex.lwn.net ([70.33.254.29]:47538 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab0DFX0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:26:38 -0400
Date: Tue, 6 Apr 2010 17:26:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Documentation/development-process: add info on
 maintainers
Message-ID: <20100406172636.7f919862@bike.lwn.net>
In-Reply-To: <20100406161705.2cecd9af.randy.dunlap@oracle.com>
References: <20100406161705.2cecd9af.randy.dunlap@oracle.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 16:17:05 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> +-  Please note that most maintainers also have day jobs, so merging
> +   your patch may not be their highest priority.  If your patch is
> +   getting feedback about changes that are needed, you should either
> +   make those changes or justify why they should not be made.  If your
> +   patch has no review complaints but is not being merged by its
> +   appropriate subsystem or driver maintainer, you should be persistent
> +   in updating the patch to the current kernel so that it applies cleanly
> +   and keep sending it for review & merging.

I'd prefer to spell out "and" in that last line, being the sort of
person that I am.  Either way:

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
