Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2C1PYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:24:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2C1PYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:24:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7 0/6] Introduce External Connector Class (extcon)
Date: Wed, 28 Mar 2012 15:24:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, cw00.choi@samsung.com
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com> <CAJ0PZbTScHq0MMjSWZ0X5qHChhS+6TL-xSnsqEwS34N2VFLaSw@mail.gmail.com> <20120328144450.GA19030@kroah.com>
In-Reply-To: <20120328144450.GA19030@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203281524.08021.arnd@arndb.de>
X-Provags-ID: V02:K0:QhFzCqmWfw9ob/wPonZuSHfXSB/CCVNHyV13+JZacfc
 Xyk2fHTFGgNQetfMMVpmMYRCEv6dh8ctuoU9wHqsg/sLxMnFBX
 lZ7jRu/+z3BmmzgnyVTfhcGF8VMguhZPTudmD4ecD3Qd9xFJGa
 bCJiv7MCm96UE+LclYEf2bXXyyywbPlP8dwF7zAQX319GMaoU/
 UpkOB/4OUIYTTERp5YY8J6dj/kcrupjxWvn4gJaoc63tmvi9Ag
 1vTaYL6oXznSbgcJasdy2wZK4KW5eXeb5OAbbI39RFc8n2gHg1
 w76jW8CUudVrtL54ZLwbGKJD4E2eRyKEBBlBn4ijeG6KZa7rhD
 4aDED4Bvrn9ZfyhPH79Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2012, Greg KH wrote:
> 
> On Wed, Mar 28, 2012 at 06:39:08PM +0900, MyungJoo Ham wrote:
> > Dear Arnd,
> > 
> > Could you please consider the EXTCON patchset for the current merge window?
> 
> Wait, no, the current merge window for new stuff closed a week or so
> before 3.3 came out.  This needs to be in linux-next before the merge
> window opens to ensure that things work properly there before it can be
> accepted into the mainline tree.
> 
> So this could go into 3.5 at the earliest.

Right. I'm also not convinced that arm-soc is the right place for this to
go, and I had not planned to add the patches there. Unfortunately I also
haven't followed the last few versions and will have to do at least one
more review round and Ack/Nak the interfaces. I should probably do that
once -rc1 is out, so please send me a reminder if you don't hear back from
me in time.

Any opinions on which tree this should go through? I could take it into
arm-soc, but it's not really ARM-only. Maybe having it go through the
staging tree would be better, leaving MyungJoo in charge afterwards.
I guess we should also add a MAINTAINERS entry for the new subsystem.

	Arnd
