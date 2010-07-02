Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0GBAtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:49:11 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46248 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab0GBAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:49:09 -0400
X-Sasl-enc: oPRvKCz/SPJYPZVYJ50fDHCKj44WZAuUWeRcpxdaFem7 1278031747
Date: Thu, 1 Jul 2010 21:49:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jerome Lacoste <jerome.lacoste@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100702004903.GC15824@khazad-dum.debian.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
 <20100701162454.GD4152@core.coreip.homeip.net>
 <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
 <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jul 2010, Jerome Lacoste wrote:
> The discussion is in particular here:
> http://lkml.indiana.edu/hypermail/linux/kernel/0809.0/0316.html

Which lists firmware version 61ET20WW, which according to:
http://www-307.ibm.com/pc/support/site.wss/document.do?lndocid=MIGR-67008

is a *VERY* outdated BIOS.

And it looks like there are two firmware versions (61* and 63*).  And many
releases.  If the BIOS update program also upgrades the EC, it can very well
fix i8042-related problems, since it is usually emulated by EC firmware.

Doesn't look like a quirk you can tie to just model type.  And if you do,
the three last letters usually doesn't mean much on any Lenovo or IBM box.
The first four are the main model type.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
