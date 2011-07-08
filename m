Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1GHWQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:16:00 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:1749 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751784Ab1GHWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:15:59 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzz8275dhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E178193.2090905@freescale.com>
Date: Fri, 8 Jul 2011 17:15:47 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
        <arnd@arndb.de>
Subject: Re: tty/powerpc: introduce the ePAPR embedded hypervisor byte channel
 driver
References: <1305830092-20104-1-git-send-email-timur@freescale.com> <20110708220654.GA19146@kroah.com>
In-Reply-To: <20110708220654.GA19146@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Doesn't apply at all to the tty-next tree, so I can't apply it here :(

Um, where exactly is the tty-next tree?  The only thing I see that looks like it
is this:

git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git

But the description of this tree says, "junk tree, please ignore".

-- 
Timur Tabi
Linux kernel developer at Freescale

