Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030472Ab2CWU1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2CWU1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:27:18 -0400
Date: Fri, 23 Mar 2012 16:27:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: jim.cromie@gmail.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [00/11] pr_debug during module initialization
Message-ID: <20120323202713.GA6039@redhat.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 05:01:55PM -0600, jim.cromie@gmail.com wrote:
> This is 3rd revision of the dyndbg modinit patches, previously sent
> Dec 11.  Patches 1-17/25 sent then were added to driver-core-next,
> this set reworks the remainder.
> 
> It implements the "fake" module param approach proposed by
> Thomas Renninger, back in https://lkml.org/lkml/2010/9/15/397
> 

Hi,

I'm wondering, if we leave the cmdline parameter: 'ddebug_query=' around
for a bit before removing it, so it doesn't get dropped too suddenly.
Perhaps, we add a warning msg, for people that are still using it
for a few releases warning that it is deprecated, before dropping it.

Also, let's add the 'dyndbg=' syntax to Documentation/kernel-parameters.txt.

A previous version had a build-time error if a module used 'dyndbg' as a
module param - why did that get dropped?

Thanks!

-Jason
