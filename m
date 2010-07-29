Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0G2CuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 22:50:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54275 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab0G2CuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 22:50:03 -0400
X-Sasl-enc: 3F5eblRIawk/o3VRsn1uGPgz6Z+Z0aHcYhKG5GIuXqjJ 1280371796
Date: Wed, 28 Jul 2010 23:49:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, tuxonice-devel@tuxonice.net,
        kgdb-bugreport@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>,
        dm-crypt@saout.de
Subject: Re: kcryptd oops when resuming with TuxOnIce with KDB oops
 afterwards
Message-ID: <20100729024951.GC6247@khazad-dum.debian.net>
References: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, Pedro Ribeiro wrote:
> I hit a bug when resuming with TuxOnIce. At the middle of a resume, it
> says Compress Read -22 and locks up. I caught the stack trace with kdb
> and took photos of that.

Maybe this?
http://lkml.org/lkml/2010/7/28/398

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
