Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1AaTNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:13:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab1AaTNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:13:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Mon, 31 Jan 2011 20:12:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101311933.38050.rjw@sisk.pl> <4D4701B7.8030004@pardus.org.tr>
In-Reply-To: <4D4701B7.8030004@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101312012.42393.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Ozan Çağlayan wrote:
> On 31.01.2011 20:33, Rafael J. Wysocki wrote:
> 
> >
> > Would it be possible to check if running the kernel in uniprocessor mode
> > makes the problem go away?
> 
> If that's the equivalent of booting with maxcpus=0, I now told them to 
> give it a try.

Booting with maxcpus=0 also disables the I/O APIC, which probably is a bit too
much, but let's see what happens in that case.

Rafael
