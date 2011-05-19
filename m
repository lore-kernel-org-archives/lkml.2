Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893Ab1ESVev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:34:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934861Ab1ESVeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:34:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: pci 0000:0a:00.0: Refused to change power state, currently in D3
Date: Thu, 19 May 2011 23:35:22 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <936833.81097.qm@web161805.mail.bf1.yahoo.com> <201105151526.41801.rjw@sisk.pl> <576614.9833.qm@web161818.mail.bf1.yahoo.com>
In-Reply-To: <576614.9833.qm@web161818.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105192335.22414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011, Mikko Vinni wrote:
> From: Rafael J. Wysocki:
> 
> >>  in an HP Pavilion dv5 laptop model dv5-1250eo always at resume
> >>  from s2ram the following messages are printed:
> >> 
> >>  pci 0000:0a:00.0: Refused to change power state, currently in D3
> >>  pci 0000:0a:00.1: Refused to change power state, currently in D3
> >>  pci 0000:0a:00.2: Refused to change power state, currently in D3
> >>  pci 0000:0a:00.3: Refused to change power state, currently in D3
> >>  pci 0000:0a:00.4: Refused to change power state, currently in D3
> > 
> > The lspci output indicates that this is a single multi-function
> > device that doesn't change its power state when programmed to go
> > into D0.  Perhaps it requires a power resource that is not available
> > at the point we're trying to restore those devices' registers.
> > 
> > Hard to say what that may be, though.  Please attach the output of
> > acpidump from the affected system.
> 
> Here it goes. Hopefully it contains the necessary parts and is not
> too big for the lists (produced without any parameters to acpidump):

Thanks.  Unfortunately, I didn't have the time to look into it.

Could you please go to https://bugzilla.kernel.org/show_bug.cgi?id=35452
and attach the acpidump output?

Rafael
