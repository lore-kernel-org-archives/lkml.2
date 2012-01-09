Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2AIVuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:50:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab2AIVuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:50:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bastien ROUCARIES <roucaries.bastien@gmail.com>
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot
Date: Mon, 9 Jan 2012 22:53:44 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <201111160019.51303.rjw@sisk.pl> <201201091700.09318.roucaries.bastien@gmail.com>
In-Reply-To: <201201091700.09318.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201092253.44329.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 09, 2012, bastien ROUCARIES wrote:
> Le Wednesday 16 November 2011 00:19:51, Rafael J. Wysocki a écrit :
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Dell OptiPlex 990 is known to require PCI reboot, so add it to the reboot
> > blacklist in pci_reboot_dmi_table[].
> 
> 
> Sorry to hi jack this thread but it seems that dell made the same crap with my precision T1600. See 
> http://www.centos.org/modules/newbb/print.php?form=1&topic_id=32948&forum=55&order=ASC&start=0
> or
> https://bugzilla.redhat.com/show_bug.cgi?id=698239

Any chance to send the output of dmidecode from that machine?

Rafael
