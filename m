Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1FTPUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:20:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43607 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1FTPUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sdngELRj6+zLG3WBzP3RD88te7pXmDnrQ594PKOVeJfB4Ar9ZHMev0h5I5EzIAQ4Sd
         pKd4PKRj3piiGa4/olZiPdIboft8ZDYCpUd3vfIQYBf9cTMpp57yHBo2MudJ2ViGonGD
         sjppSr5j7NVoonsC4fDGsNamYEztVRMvCDTVA=
MIME-Version: 1.0
In-Reply-To: <20110620151522.GN14262@legolas.emea.dhcp.ti.com>
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
	<Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
	<20110620151522.GN14262@legolas.emea.dhcp.ti.com>
Date: Mon, 20 Jun 2011 17:20:02 +0200
Message-ID: <BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Skacore Systems <skacore.systems@gmail.com>
To: balbi@ti.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been exactly following
http://www.kernel.org/doc/Documentation/SubmittingPatches:

To create a patch for a single file, it is often sufficient to do:

	SRCTREE= linux-2.6
	MYFILE=  drivers/net/mydriver.c

	cd $SRCTREE
	cp $MYFILE $MYFILE.orig
	vi $MYFILE	# make your change
	cd ..
	diff -up $SRCTREE/$MYFILE{.orig,} > /tmp/patch

And that's what I've done. What do you think is wrong with it ???

Vilo


On Mon, Jun 20, 2011 at 5:15 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jun 20, 2011 at 11:07:51AM -0400, Alan Stern wrote:
>> On Mon, 20 Jun 2011, Viliam Mateicka wrote:
>>
>> > So, will somebody at least react/reply (or just fix) ?
>>
>> Have some patience.  You did not address your email message to either
>> of the driver's authors or to the current Gadget maintainer.  Also,
>> David Brownell is deceased and Greg KH is on vacation.
>
> besides, the patch formatting is wrong. That was noted before and the
> reply was less than acceptably polite, so unless the patch comes
> Perfect(TM), I'm not looking into it.
>
> --
> balbi
>
