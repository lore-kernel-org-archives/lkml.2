Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465Ab0GPDBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:01:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58393 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935288Ab0GPDBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:01:13 -0400
X-Sasl-enc: wImzDd5jlVgIUPVW9k+QYInGSN3NptkbVsPdAxTbjB7W 1279249269
Date: Fri, 16 Jul 2010 00:01:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
 Lenovo T400/T500
Message-ID: <20100716030107.GH27512@khazad-dum.debian.net>
References: <4C3DCAA4.9050602@gmail.com>
 <20100714143625.GA30721@srcf.ucam.org>
 <20100715223149.GC27512@khazad-dum.debian.net>
 <20100715225022.GA31377@srcf.ucam.org>
 <20100715230023.GE27512@khazad-dum.debian.net>
 <20100715230825.GA31651@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715230825.GA31651@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Matthew Garrett wrote:
> On Thu, Jul 15, 2010 at 08:00:23PM -0300, Henrique de Moraes Holschuh wrote:
> > Do you want to escalate this to Lenovo?  I need a clear and consise
> > description of the problem and the boxes we know to be affected.
> 
> Well, right now we're not doing precisely what Windows does. The other 
> possibility is that when the keyboard controller write triggers some SMM 
> code, it makes an assumption about some piece of hardware state that 
> isn't true and loops for a while to see if it changes. If we knew what 
> that was then we could ensure that we're performing the same state 
> change on our way down to reboot.
> 
> One thing that would be worth checking is whether performing the 
> keyboard controller writes from userspace with a minimal kernel and 
> init=/bin/bash shows the 9-second pause or not - and then, ideally, see 
> whether the same is also true under DOS.

I can't help much there, as the only hardware I have is a ThinkPad T43.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
