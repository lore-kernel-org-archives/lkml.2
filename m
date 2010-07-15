Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934923Ab0GOWb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:31:57 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35304 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934838Ab0GOWb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:31:56 -0400
X-Sasl-enc: kmtXzE22DcF7Uit3vo2lRaSn2DMoMWZOeeO8YZIlKaPY 1279233112
Date: Thu, 15 Jul 2010 19:31:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pedro Ribeiro <pedrib@gmail.com>, ibm-acpi-devel@lists.sourceforge.net,
        eusou15@yahoo.com, linux-kernel@vger.kernel.org,
        toralf.foerster@gmx.de
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
 Lenovo T400/T500
Message-ID: <20100715223149.GC27512@khazad-dum.debian.net>
References: <4C3DCAA4.9050602@gmail.com>
 <20100714143625.GA30721@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714143625.GA30721@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Matthew Garrett wrote:
> There's two possibilities here:
> 
> 1) Lenovo's firmware is broken and the 9-second delay is always going to 
> be there. In that case we should try to use the ACPI reboot vector 
> first.

Or maybe we should key into whatever OSI() the ACPI firmware asked, and try
first whatever shutdown path the highest version of Windows asked for by the
firmware would.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
