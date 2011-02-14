Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1BNWuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:50:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44563 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab1BNWuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:50:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
Date: Mon, 14 Feb 2011 23:50:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: castet.matthieu@free.fr, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
References: <4D473FD5.1090903@free.fr> <1297108754.4d504f1281802@imp.free.fr> <4D599C6F.60600@zytor.com>
In-Reply-To: <4D599C6F.60600@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102142350.04053.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 14, 2011, H. Peter Anvin wrote:
> On 02/07/2011 11:59 AM, castet.matthieu@free.fr wrote:
> >
> > For .39 I hope we could remove most of the RWX rights after init (This means
> > make low memory trampoline NX or !RW).
> 
> By the way, I think this is the wrong goal.  I think we should have
> things enabled at their lowest permission level *as early as possible*.
>  The current model of tightening down permissions late in the boot is
> really the wrong model.

FWIW, I agree.

Rafael
