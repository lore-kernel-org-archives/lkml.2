Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0GFLga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:36:30 -0400
Received: from www.humilis.net ([82.95.169.224]:57002 "EHLO attic.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab0GFLg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:36:29 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jul 2010 07:36:28 EDT
Date: Tue, 6 Jul 2010 13:26:50 +0200
From: Sander <sander@humilis.net>
To: Mark Knecht <markknecht@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
       Stan Hoeppner <stan@hardwarefreak.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
Message-ID: <20100706112650.GA28794@attic.humilis.net>
Reply-To: sander@humilis.net
References: <AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
 <4C2F87C1.8000701@hardwarefreak.com>
 <AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>
 <4C2F9292.708@hardwarefreak.com>
 <AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com>
 <AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
 <4C31796C.8050209@kernel.org>
 <AANLkTinvNGha7SfaAWYIjUJwR9ZelCbHAWK0qvvllF9S@mail.gmail.com>
 <4C3271FF.9080308@gmail.com>
 <AANLkTilAvJUthkXM7KL9BhLwEv9kJn31Rs8wDTAe4PlY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilAvJUthkXM7KL9BhLwEv9kJn31Rs8wDTAe4PlY@mail.gmail.com>
X-Uptime: 13:18:50 up 2 days, 22:22, 17 users,  load average: 2.25, 2.17,
 2.21
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Knecht wrote (ao):
> On Mon, Jul 5, 2010 at 4:59 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > On some machines changing from IDE to AHCI messes up the boot order
> > selection in the BIOS - you may have to switch to AHCI, save settings,
> > reboot, go back into the BIOS and then make sure the disk boot order
> > settings are correct (whatever drive grub is installed on needs to be
> > first).
> 
> That's a very interesting idea Robert. Thanks.
> 
> I'll have to be careful. I have 5 identical drives in the machine so
> figuring out which is which when I'm in BIOS might be a bit of a
> trick.
> 
> I'll give it a go and report back.

You can install grub on the mbr of all disks and not worry about the
order. Especially if you work with UUIDs.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
