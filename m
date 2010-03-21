Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0CUXNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:13:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0CUXNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:13:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: Resume problem with radeon+KMS (2.6.34-rc2 and before)
Date: Mon, 22 Mar 2010 00:16:08 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?iso-8859-1?q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
References: <201003212228.13923.rjw@sisk.pl> <201003220007.44981.rjw@sisk.pl> <21d7e9971003211610h268e10e8oc9ecf06390e421b9@mail.gmail.com>
In-Reply-To: <21d7e9971003211610h268e10e8oc9ecf06390e421b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003220016.08424.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010, Dave Airlie wrote:
> On Mon, Mar 22, 2010 at 9:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday 21 March 2010, Dave Airlie wrote:
> >> 2010/3/22 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > Hi,
> >> >
> >> > Some time ago I reported a problem with resuming from suspend to RAM on
> >> > HP nx6325 with radeon+KMS.
> >>
> >> Can you post the X.org log file? if you are really using 6.12.4 and
> >> not a backport
> >> then the userspace driver has no KMS support and it is trashing the system.
> >
> > Appended below.
> >
> 
> So your userspace is incompatible with KMS, so I'd suggest trying to
> get 6.12.191
> or -ati git master,

Thanks a lot, I will.

Rafael
