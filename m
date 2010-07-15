Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968Ab0GOXA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:00:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35861 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934946Ab0GOXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:00:27 -0400
X-Sasl-enc: eYRorOgjuVpl6Gt3K7Flxl3IGalUBSqjqSySsloBjBhz 1279234825
Date: Thu, 15 Jul 2010 20:00:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
 Lenovo T400/T500
Message-ID: <20100715230023.GE27512@khazad-dum.debian.net>
References: <4C3DCAA4.9050602@gmail.com>
 <20100714143625.GA30721@srcf.ucam.org>
 <20100715223149.GC27512@khazad-dum.debian.net>
 <20100715225022.GA31377@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715225022.GA31377@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Matthew Garrett wrote:
> On Thu, Jul 15, 2010 at 07:31:49PM -0300, Henrique de Moraes Holschuh wrote:
> > Or maybe we should key into whatever OSI() the ACPI firmware asked, and try
> > first whatever shutdown path the highest version of Windows asked for by the
> > firmware would.
> 
> I've been tracing how Windows implements reboots (XP, Vista and 7). It 
> appears to use the ACPI reboot vector, the keyboard controller, the ACPI 
> reboot vector again, the keyboard controller again and then hangs. I'll 
> try implementing equivalent behaviour in Linux and see whether it makes 
> any difference.

Icky.  It doesn't happen always, but this time it does looks like we will
NOT be better off doing whatever Windows is doing.

Do you want to escalate this to Lenovo?  I need a clear and consise
description of the problem and the boxes we know to be affected.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
