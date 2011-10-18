Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1JRBMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:12:02 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54890 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab1JRBMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:12:00 -0400
X-Sasl-enc: 6YDehgtuNPxRsaGL8gjk9t8jRH1bYB7jgB671NaVrCTH 1318900319
Date: Mon, 17 Oct 2011 23:11:56 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for
 microcode update in Xen dom0
Message-ID: <20111018011156.GA20291@khazad-dum.debian.net>
References: <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
 <20111012214013.GD28723@aftab>
 <4E96198F.4030906@zytor.com>
 <20111013073352.GB501@aftab>
 <20111013095708.GA1862@aftab>
 <20111017170854.GE19756@phenom.dumpdata.com>
 <4E9C6886.20600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C6886.20600@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, H. Peter Anvin wrote:
> On 10/17/2011 10:08 AM, Konrad Rzeszutek Wilk wrote:
> > <scratches his head>
> > You are still using the microcode API (the existing one) to
> > program the CPUs right? It is just that you are fetching the images
> > much much earlier than it currently is done?
> > 
> 
> No, the goal is to ditch the existing API and load the CPUs very early
> in the start path.

And how do we apply new microcode at runtime?  A new API?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
