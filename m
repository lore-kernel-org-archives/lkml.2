Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab1CAU2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:28:25 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59754 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148Ab1CAU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:28:23 -0500
X-Sasl-enc: xCfPrljn4FcaE3dCXV7/qwU/xjz6pgcM/goKeatWZYhj 1299011303
Date: Tue, 1 Mar 2011 17:28:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] ThinkPad T400 : should kernel option
 "reboot=pci" be hard	coded ?
Message-ID: <20110301202812.GB25758@khazad-dum.debian.net>
References: <201006071122.21925.toralf.foerster@gmx.de>
 <201006091343.48924.toralf.foerster@gmx.de>
 <AANLkTimkWN5tU88J-M3Q4aq9pq-WljyyPAUPfnf9cuhf@mail.gmail.com>
 <201103010940.13647.toralf.foerster@gmx.de>
 <20110301123520.GA30115@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110301123520.GA30115@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Mar 2011, Matthew Garrett wrote:
> On Tue, Mar 01, 2011 at 09:40:13AM +0100, Toralf Förster wrote:
> > I'd like to point to this after a half year of lthe last email. Shouldn't it 
> > be hard coded ?
> 
> Windows appears to have exactly the same behaviour, so it seems that 
> this is working like designed.

Which makes this "something we could ask Lenovo" about.  The standard rules
apply.  Assuming you do not have direct contacts in the Lenovo BIOS team
yourself, send me or to Thomas Renninger a full description of the observed
problem, and of our workaround, and what you'd like to know (e.g: what is
causing the delay?).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
