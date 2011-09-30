Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1I3UUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:20:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40400 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab1I3UUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:20:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zan Lynx <zlynx@acm.org>
Subject: Re: Samsung Series 9 seems to require acpi=nonvs to resume properly
Date: Fri, 30 Sep 2011 22:22:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1317329529.3151.10.camel@knife> <1317413360.2629.2.camel@knife>
In-Reply-To: <1317413360.2629.2.camel@knife>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109302222.22528.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 30, 2011, Zan Lynx wrote:
> On Thu, 2011-09-29 at 14:51 -0600, Zan Lynx wrote:
> > After being annoyed that the latest Fedora 2.6.40 (aka 3.0 something)
> > kernels would not suspend/resume on my laptop I followed a Ubuntu forum
> > suggestion to use acpi=nonvs. This worked, or at least it is working
> > today with Fedora 15's 2.6.40.4-5.fc15.x86_64.
> > 
> > The system is also booting via UEFI if that makes any difference.
> > 
> > I understand that there is a no-NVS blacklist in the kernel. Should the
> > Samsung Series 9 be added to this list? Or could it be a different
> > suspend/resume problem entirely?
> 
> Please ignore this about nonvs. nonvs has nothing to do with the
> suspend/resume problem on this laptop.
> 
> Instead it seems to involve reboots, which is crazy. From a cold
> power-on start, suspend resume will always fail. But if the laptop is
> rebooted first, suspend and resume appear to work. What the heck? I have
> no clue how to debug this.
> 
> So now it appears that everything I ever tried to fix this only seemed
> to work because I rebooted after changing GRUB or module options.

What graphics is there in the system?

Rafael
