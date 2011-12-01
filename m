Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1LAVUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:20:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1LAVUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:20:23 -0500
Date: Thu, 1 Dec 2011 16:20:17 -0500
From: Jason Baron <jbaron@redhat.com>
To: jim.cromie@gmail.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/25] dynamic-debug during module initialization
Message-ID: <20111201212017.GE2443@redhat.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:56:29PM -0700, jim.cromie@gmail.com wrote:
> This patchset adds
> - dynamic-debug during module initialization
> - multiple queries
> 
> Unlike previous versions, this drops pending-query approach in
> favor of "fake module parameter" approach proposed by Thomas Renninger.
>     https://lkml.org/lkml/2010/9/15/397
> 
> Its based upon v3.2-rc3, cuz it includes a few adjustments to
> dynamic_debug.h which are not in driver-core-next atm.
> 
> 
> 1	bug-fix for kernel/module.c under DEBUGP
> 2	whitespace cleanup
> 3-12	dynamic-debug cleanups, should be relatively uncontroversial
> 13-17	multiple queries in ddebug_query="..."
> 
> 18-25	fake module parameter
> 20	maybe fold into 18 (kept separate since 18 is Thomas's work)
> 23	*.dyndbg=...
> 25	BUILD_BUG_DECL (likely discussion point ;-)
> 

I like 25, it truly makes 'dyndbg' a reserved module parameter, which is the
intention.

