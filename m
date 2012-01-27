Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2A0UGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:06:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46453 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2A0UGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:06:21 -0500
Date: Fri, 27 Jan 2012 12:05:52 -0800
From: Kees Cook <kees@ubuntu.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [PATCH 0/4] AppArmor: refactor securityfs to use structures
Message-ID: <20120127200551.GV4592@outflux.net>
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
 <4F22F2D4.4080605@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F22F2D4.4080605@schaufler-ca.com>
Organization: Ubuntu
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

On Fri, Jan 27, 2012 at 10:54:12AM -0800, Casey Schaufler wrote:
> On 1/26/2012 4:29 PM, Kees Cook wrote:
> >This is the ground-work for expanding the AppArmor securityfs to include
> >useful information that the userspace tools can more easily interact with.
> >Presently, this is only static information about the state of AppArmor.
> 
> If you're making changes for securityfs do you suppose that
> you might do all of us LSM developers a huge favor and add an
> entry that reports the active LSM? It's something that has been
> on my todo list for ages and would make everyone's life so much
> easier. /sys/kernel/security/LSM which contains the name of the
> active LSM would be very handy.

Should that appear in the securityfs? Normally one can just mount it
and look to see what's in there. And, I'm nervous to add a file here
without a good LSM stacking plan yet. I'd hate to create another interface
that needs to be redefined later. :)

-Kees

-- 
Kees Cook
