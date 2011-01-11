Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1AKEbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:31:03 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:58120
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754557Ab1AKEa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:30:56 -0500
Date: Tue, 11 Jan 2011 04:32:14 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Bastian Blank <bastian@waldi.eu.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110111043214.GA24770@mail.hallyn.com>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
 <20110110225151.GA18944@localhost>
 <4D2BDAF4.9040908@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2BDAF4.9040908@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
...
> > If permission is granted based on userids and the capability
> > isn't needed, then we don't want to needlessly set PF_SUPERPRIV.
> 
> A bit off-topic: does this means that c/r needs to save and 
> restore this process flag ?

It should, yeah.  (Until we decide to nuke the flag)

thanks,
-serge
