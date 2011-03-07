Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1CGUi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:38:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1CGUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:38:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Bug #29312] Unmounting fails even after the underlying device is long gone
Date: Mon, 7 Mar 2011 21:38:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera> <GTlFTeOGjrB.A.DoE.Sq3cNB@chimera> <AANLkTimPYKP8S24ivRZXePhc5wM6n3ivzdpJSBaCvG6a@mail.gmail.com>
In-Reply-To: <AANLkTimPYKP8S24ivRZXePhc5wM6n3ivzdpJSBaCvG6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103072138.27118.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 07, 2011, Bart Van Assche wrote:
> On Sun, Mar 6, 2011 at 1:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=29312
> > Subject         : Unmounting fails even after the underlying device is long gone
> > Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> > Date            : 2011-02-17 19:20 (18 days old)
> 
> Unmounting works fine again with 2.6.38-rc7+, but I see now a huge
> number of error messages in the system log:
> # grep -c '^Mar  7 18:37:4.* kernel: sd 6:0:0:0: rejecting I/O to
> offline device$' /var/log/messages
> 4987

Well, that probably is a different issue ...

Thanks for the update.

Rafael
