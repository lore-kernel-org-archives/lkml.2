Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1EIWT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:19:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab1EIWTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:19:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the final tree (driver-core tree related)
Date: Tue, 10 May 2011 00:19:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Guda <atu@dmeti.dp.ua>
References: <20110509145854.9e6d8806.sfr@canb.auug.org.au> <BANLkTinzFs0cfGdmkdOE8cgKSHK=5NEjmg@mail.gmail.com>
In-Reply-To: <BANLkTinzFs0cfGdmkdOE8cgKSHK=5NEjmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105100019.52936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 09, 2011, Kay Sievers wrote:
> On Mon, May 9, 2011 at 06:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the final tree, today's linux-next build (powerpc allnoconfig)
> > failed like this:
> >
> > kernel/sys.c: In function 'kernel_restart_prepare':
> > kernel/sys.c:317: error: implicit declaration of function 'usermodehelper_disable'
> 
> Rafael, seems usermodehelper_disable() depends on CONFIG_PM_SLEEP.
> 
> Any reason for that conditional? Remove it now?

Aw, we have two conflicting changes.  Could you prepare a patch on top of:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-next

removing that #ifdef?  That needs to be done in kmod.h too.

Thanks,
Rafael
