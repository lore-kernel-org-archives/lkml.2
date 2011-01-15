Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1AOA3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:29:48 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:45037
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751320Ab1AOA3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:29:46 -0500
Date: Sat, 15 Jan 2011 00:31:14 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Bastian Blank <bastian@waldi.eu.org>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110115003114.GA24569@mail.hallyn.com>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
 <20110110225151.GA18944@localhost>
 <20110110232335.GA27029@wavehammer.waldi.eu.org>
 <20110111013152.GA23860@mail.hallyn.com>
 <20110114145001.GB20945@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114145001.GB20945@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> On Tue, Jan 11, 2011 at 01:31:52AM +0000, Serge E. Hallyn wrote:
> > Quoting Bastian Blank (bastian@waldi.eu.org):
> > > What is this flag used for anyway? I only see it used in the accounting
> > > stuff, and if every user can get it, it is not longer useful.
> > hm, I'm not sure...  maybe noone is using it!
> 
> This flag is from pre-git.
> 
> The only information is:
> | #define ASU                0x02    /* ... used super-user privileges */
> 
> However with your patches (or at least the goal), everyone is super-user
> in derived namespaces.

No, a task just sitting in a derived ns won't necessarily need/use
super-user privileges...  (and, if we ever get far enough along, it
won't even necessarily have CAP_SYS_ADMIN/etc targeted to the parent
userns, bc it won't need those to do the unshares).

thanks,
-serge
