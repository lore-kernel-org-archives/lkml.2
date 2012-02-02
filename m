Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2BBEEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 23:04:32 -0500
Received: from mail.tomasu.net ([64.85.170.232]:46482 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab2BBEEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 23:04:25 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas with 3.1)
Date: Wed, 1 Feb 2012 21:04:20 -0700
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: John Robinson <john.robinson@anonymous.org.uk>,
        "linux-raid" <linux-raid@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010742.07818.thomas@fjellstrom.ca> <4F29FCB2.6040204@fnarfbargle.com>
In-Reply-To: <4F29FCB2.6040204@fnarfbargle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202012104.20564.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Feb 1, 2012, Brad Campbell wrote:
> On 01/02/12 22:42, Thomas Fjellstrom wrote:
> > Yeah, GRUB immediately throws an "out of memory. Aborted" error, its
> > annoying, but I reported the issue on GRUB's bug tracker after talking
> > to a guy in #grub on freenode. Hopefully someone looks at it soon. It
> > appears it happens so early in grub's startup that it can't even output
> > any debug info (I was asked to run: `grub-install --debug-image=all
> > /dev/sdX`, and did so, I get debug output when the card is not
> > installed, but absolutely nothing when it is installed.
> 
> Just another data point. I've seen this issue also. It does not appear to
> be GRUB's fault. It appears the BIOS on the card does something funky as
> it also prevents syslinux/isolinux/pxelinux and its friends from properly
> detecting/reporting the machines memory. Machine has 16GB but a PXE boot
> believes it has 3GB.
> 
> I "worked around" the problem by swapping out the mainboard for a later
> model with a different BIOS and the problem went away. Not pretty, but it
> was the only way I could get the machine to boot with those cards in it. I
> have 4 IBM cards in 2 machines and they work fine here. I still have the
> dodgy mainboard and can set it up if you need help testing/reproducing the
> issue.

I meant to do some testing on it tonight, but that doesn't seem like its going 
to happen. Basically I'm going to try that grub change and see if it helps, if 
you have the time, and desire to help, that would be nice, but I'm most likely 
going to try it out tomorrow sometime regardless.

> Regards,
> Brad


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
