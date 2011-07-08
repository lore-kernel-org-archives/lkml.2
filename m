Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1GHS6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:58:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1GHS6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:58:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/7] pm: improve error code of pm_notifier_call_chain()
Date: Fri, 8 Jul 2011 20:59:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-pm@lists.linux-foundation.org,
        Jiri Kosina <jkosina@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com> <201107072306.02708.rjw@sisk.pl> <CAC5umyhZ35AXtwA=Uy1+zp9N=NwLths=h6jKUK53f0U+tZMZZA@mail.gmail.com>
In-Reply-To: <CAC5umyhZ35AXtwA=Uy1+zp9N=NwLths=h6jKUK53f0U+tZMZZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107082059.57530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 08, 2011, Akinobu Mita wrote:
> 2011/7/8 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday, July 04, 2011, Akinobu Mita wrote:
> >> 2011/7/4 Pavel Machek <pavel@ucw.cz>:
> >> > On Sun 2011-07-03 23:16:15, Akinobu Mita wrote:
> >> >> This enables pm_notifier_call_chain() to get the actual error code
> >> >> in the callback rather than always assume -EINVAL by converting all
> >> >> PM notifier calls to return encapsulate error code with
> >> >> notifier_from_errno().
> >> >>
> >> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> >> Cc: Pavel Machek <pavel@ucw.cz>
> >> >
> >> > Nothing obviously wrong here.
> >>
> >> Thanks. Can I add your ACK for this patch?
> >
> > Do you want me to take this patch?
> 
> Yes, please merge it to your tree.

Applied.

Thanks,
Rafael
