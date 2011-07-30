Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab1G3F2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 01:28:30 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:57325 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751978Ab1G3F22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 01:28:28 -0400
Date: Sat, 30 Jul 2011 07:28:26 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ide-cs
Message-ID: <20110730052826.GB12383@isilmar-3.linta.de>
Mail-Followup-To: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4E33851C.2000806@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E33851C.2000806@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry,

On Fri, Jul 29, 2011 at 11:14:20PM -0500, Larry Finger wrote:
> With kernel 3.0, my external hard drive attached to a PCMCIA card reports 
> "irq 11: nobody cared (try booting with the "irqpoll" option)". The 
> driver in question is ide-cs. When I try irqpoll, the device works 
> correctly. Naturally, the interrupt is shared with yenta, the PCMCIA 
> adapter driver. In addition, that same interrupt is used by a BCM4318 
> Cardbus device.
>
> I plan on preparing a Bugzilla entry for this problem, but I'm not quite 
> ready. What I would like to know if there is any documentation on what 
> kinds of changes are needed to fix the problem.

Let me guess: it worked fine in 2.6.39, or .38? Output of "lspci -vv",
"dmesg" for a working and a non-working kernel would be good starting points
for trying to debug this issue.

Best,
	Dominik
