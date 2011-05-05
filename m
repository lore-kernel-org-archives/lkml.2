Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1EEUCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:02:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1EEUCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:02:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the suspend tree
Date: Thu, 5 May 2011 22:02:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>
References: <20110505121117.3b9b3fb3.sfr@canb.auug.org.au>
In-Reply-To: <20110505121117.3b9b3fb3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105052202.46364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 05, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the suspend tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "usermodehelper_is_disabled" [drivers/base/firmware_class.ko] undefined!
> 
> Caused by commit d5fef1145404 ("PM: Print a warning if firmware is
> requested when tasks are frozen").

Hmm.  If that's what I think (a missing EXPORT_SYMBOL), it should be
fixed now.

Thanks,
Rafael
