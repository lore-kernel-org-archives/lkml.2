Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0CSQGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:06:47 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46922 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab0CSQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:06:45 -0400
X-Sasl-enc: +GW2HMREBXsX54QYatm56IeOhnbnx4jCf6O7LuvSVRpR 1269014804
Date: Fri, 19 Mar 2010 13:06:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100319160641.GC16743@khazad-dum.debian.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
 <20100319000043.GC12017@khazad-dum.debian.net>
 <20100319000931.GA5671@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319000931.GA5671@core.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010, Dmitry Torokhov wrote:
> On Thu, Mar 18, 2010 at 09:00:43PM -0300, Henrique de Moraes Holschuh wrote:
> > Any chance of the user being able to avoid the SysRQ events getting to the
> > handle, e.g. by opening the input device in exclusive mode or something like
> > that?
> 
> Yes, it is a possible to suppress SysRq by grabbing an input device.
> This possibility exisst with the current implementation too though -
> after all legacy keyboard driver implemented as an input handler as
> well.
> 
> ... or am I answering a question different from the one you asked? ;)

No, that's exactly what I wanted to know.

What about SAK?  That thing *has* to be untrappable.

Even for the SysRQ debug events, I'd feel better if we could have a class of
system input handlers that cannot be suppressed to use for these things.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
