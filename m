Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0GHPcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:32:46 -0400
Received: from mx4.sophos.com ([74.202.89.161]:60605 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab0GHPcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:32:45 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Greg KH <greg@kroah.com>
Subject: Re: BUG: Securityfs and bind mounts (2.6.34)
Date: Thu, 8 Jul 2010 16:32:42 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <201007081112.41252.tvrtko.ursulin@sophos.com> <201007081555.01242.tvrtko.ursulin@sophos.com> <20100708152059.GA12932@kroah.com>
In-Reply-To: <20100708152059.GA12932@kroah.com>
MIME-Version: 1.0
Message-ID: <201007081632.42069.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 16:32:42,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 16:32:42,
	Serialize complete at 08/07/2010 16:32:42
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 Jul 2010 16:20:59 Greg KH wrote:
> > :) Well I do not know, but, it kind of smelled like a bug in the
> > : vfs/mount
> >
> > handling/securityfs area so I thought to let experts know. I _think_ I
> > did nothing that much wrong. Just used the exposed API
> > (securityfs_remove) and some bind mount shuffling from userspace.
>
> securitfs just uses libfs underneath it, and really doesn't have any
> bindings for module ownerships, so I wouldn't recommend doing what you
> just did.

Just do double check what you are saying, securityfs is not safe for use from
modules? If so I would then recommend removing the exports otherwise it is an
invitation to shoot yourself into the foot. Also, in-three TPM driver can be
built as a module so how does that work?

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
