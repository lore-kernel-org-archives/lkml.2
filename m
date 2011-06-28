Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1F1OIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:08:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1F1OHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:07:13 -0400
Message-ID: <DE6BB9BF2B09415FACB0F74F3CF4CF5C@Main>
From: "Arjan Mels" <arjan.mels@gmx.net>
To: "Greg KH" <greg@kroah.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "matt mooney" <mfm@muteddisk.com>
References: <20110609165804.2e96bb77.sfr@canb.auug.org.au> <20110609184206.GC2760@kroah.com> <20110609205111.GB32526@kroah.com>
In-Reply-To: <20110609205111.GB32526@kroah.com>
Subject: Re: linux-next: manual merge of the staging tree with the staging.current tree
Date: Tue, 28 Jun 2011 16:07:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 15.4.3508.1109
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3508.1109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Stephen,

Below mentioned patch does not seem to have made it into the linux-next tree 
(and other stable branches).

What do I need to do to correct this?

Best Regards,

Arjan

> > drivers/staging/usbip/stub_dev.c between commit d3ac07788017 ("staging:
> > usbip: bugfix prevent driver unbind") from the staging.current tree and
> > commit d012c2a5aca1 ("staging: usbip: stub_dev.c: move stub_driver




-----Original Message----- 
From: Greg KH
Sent: Thursday, June 09, 2011 22:51
To: Stephen Rothwell
Cc: linux-next@vger.kernel.org ; linux-kernel@vger.kernel.org ; Arjan Mels ; 
matt mooney
Subject: Re: linux-next: manual merge of the staging tree with the 
staging.current tree

On Thu, Jun 09, 2011 at 11:42:06AM -0700, Greg KH wrote:
> On Thu, Jun 09, 2011 at 04:58:04PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> >
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/usbip/stub_dev.c between commit d3ac07788017 ("staging:
> > usbip: bugfix prevent driver unbind") from the staging.current tree and
> > commit d012c2a5aca1 ("staging: usbip: stub_dev.c: move stub_driver
> > definition and update driver name") from the staging tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary.
>
> Looks correct, thanks for doing this.

This should now be resolved.

greg k-h 

