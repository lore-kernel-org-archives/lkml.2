Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1HYOlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab1HYOk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:40:58 -0400
Date: Thu, 25 Aug 2011 16:37:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: linux-next: build failure after merge of the ptrace tree
Message-ID: <20110825143758.GA2039@redhat.com>
References: <20110825141212.4f82835beaad506553e291e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825141212.4f82835beaad506553e291e8@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 08/25, Stephen Rothwell wrote:
>
> Hi all,
>
> After merging the ptrace tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> ERROR: ".set_current_blocked" [fs/autofs4/autofs4.ko] undefined!

In case you didn't notice, we are doing our best to complicate
your life :/

Sorry.

> Presumably set_current_blocked() needs to be EXPORTed.

Yes. I've reset the last 4 commits which touch the code in fs/.
Will add them back after the patch which exports set_current_blocked.

Thanks a lot!

Oleg.

