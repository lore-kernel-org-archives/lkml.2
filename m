Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1AaSeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:34:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1AaSeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:34:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Mon, 31 Jan 2011 19:33:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101311924.33098.rjw@sisk.pl> <4D46FF82.1090704@pardus.org.tr>
In-Reply-To: <4D46FF82.1090704@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101311933.38050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Ozan Çağlayan wrote:
> On 31.01.2011 20:24, Rafael J. Wysocki wrote:
> 
> >>
> >> Or just use the processor.max_cstate parameter then.
> >
> > As I wrote a couple of messages ago, https://lkml.org/lkml/2011/1/31/52 .
> 
> The users reported that processor.max_cstate=0 didn't help too. The ones 
> which experience random hangs during shutdown tells that the hard disk 
> is turned off and the fans are turning faster.
> 
> The other user which can't even boot didn't tell the result of adding 
> processor.max_cstate=0 to boot params.

Well, I'm kind of not sure what to do next.

The expectation seems to be that the problem is somehow related to cpuidle,
but the above observations fail to confirm that.

Would it be possible to check if running the kernel in uniprocessor mode
makes the problem go away?

Rafael
