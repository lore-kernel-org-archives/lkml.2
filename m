Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2I2VZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 17:25:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41414 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab2I2VZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 17:25:53 -0400
X-Sasl-enc: CP2zBQVZpnOfcjLHfI9C3tZQ26fWoCa9HWJLz5f2YNsp 1348953952
Date: Sat, 29 Sep 2012 18:25:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to
 cleanup
Message-ID: <20120929212548.GD8329@khazad-dum.debian.net>
References: <1347039854.6288.8.camel@thor>
 <504A3FA9.1050502@zytor.com>
 <504D6490.2060606@oracle.com>
 <1348853876.2229.22.camel@thor>
 <5066680E.3090907@zytor.com>
 <20120929104611.GB14974@khazad-dum.debian.net>
 <30701c46-a57e-49f2-9273-6f725c8463e0@email.android.com>
 <20120929201107.GB8329@khazad-dum.debian.net>
 <50675776.10702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50675776.10702@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2012, H. Peter Anvin wrote:
> >Intel doesn't make it easy to get all processor specification updates at
> >once so that I could hunt down every processor which acknowledges the
> >existence of that errata before replying, so I will assume for the moment
> >that the comment is mostly correct.
> 
> I should say: as far as I know the blacklist is there because noone
> has been willing to bother looking at if it actually matters, given
> how old the hardware is.

Hmm, well, I will probably have to look it up for a few processors that
matter to me, apparently.

Can't people that work at Intel at least petition for meta-index pages of
this kind of documentation?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
