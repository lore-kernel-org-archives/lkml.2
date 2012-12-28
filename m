Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2L1KKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 05:10:22 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38801 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab2L1KKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 05:10:19 -0500
X-Sasl-enc: XvyXnF/dnqpfa42MQESafAa/3RpMpKVZW76+kezzzQam 1356689417
Date: Fri, 28 Dec 2012 08:10:13 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] drivers/platform/x86/thinkpad_acpi.c:
 Handle HKEY event 0x6040
Message-ID: <20121228101013.GA15327@khazad-dum.debian.net>
References: <1356543973-18459-1-git-send-email-richih.mailinglist@gmail.com>
 <20121227103843.GB7894@khazad-dum.debian.net>
 <CAD77+gTj+EvuOTU9SZBXOv92YmBdy3EgH9vHwypeFtAJY6+Eyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD77+gTj+EvuOTU9SZBXOv92YmBdy3EgH9vHwypeFtAJY6+Eyw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012, Richard Hartmann wrote:
> On Thu, Dec 27, 2012 at 11:38 AM, Henrique de Moraes Holschuh <
> hmh@hmh.eng.br> wrote:
> 
> > /* fallthrough */
> >
> [...]
> 
> > and letting it proceed to the TP_HKEY_EV_KEY_NUMLOCK block.
> >
> 
> OK.
> 
> 
> Also, do we have any confirmed reports about the lid switch
> > causing event 0x6040?  It doesn't look right... the comment
> > might need to be updated.
> >
> 
> I could not reproduce it on my X220. Would you prefer even stronger wording
> or should I get of it entirely?

If you cannot reproduce it, we can shalk it up to user error or to corrected
firmware bug, so you can remove any mention of lid open/close to event
6040...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
