Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1BCWwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:52:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1BCWwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:52:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Thu, 3 Feb 2011 23:51:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201102032304.46724.rjw@sisk.pl> <4D4B2883.4020701@pardus.org.tr>
In-Reply-To: <4D4B2883.4020701@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102032351.31307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 03, 2011, Ozan Çağlayan wrote:
> On 04.02.2011 00:04, Rafael J. Wysocki wrote:
> 
> >
> > I guess we see a few different problems here.
> >
> > Can you remind me, please, what the known workarounds are?
> 
> OK in summary:
> 
> ASUS X71S - Doesn't boot without nolapic
> ASUS F50SV - Doesn't boot without nolapic (latest tried and working 2.6.31)
> ASUS N61JQ - X out of Y shutdown hangs (Cured with nolapic too)
> 
> Note that nolapic is the finer grained fix. acpi=off fixes the issue too.

Hmm.  Are those boxes uniprocessor running SMP kernels?

Rafael
