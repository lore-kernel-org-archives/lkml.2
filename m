Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2DPSPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:15:14 -0400
Received: from inf-mxout4.simplymailsolutions.com ([88.151.129.24]:36271 "EHLO
	inf-mxout4.simplymailsolutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075Ab2DPSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:15:12 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 14:15:10 EDT
From: Robert Scott <bugs@humanleg.org.uk>
Reply-To: bugs@humanleg.org.uk
Organization: none
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Date: Mon, 16 Apr 2012 19:05:05 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>, mingo@redhat.com,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        JBeulich@novell.com, xen-devel@lists.xensource.com,
        Lars Boegild Thomsen <lth@cow.dk>,
        e568b31a443d@6cc2cce7af2d.anonbox.net,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <20110829041532.GA22087@elie.gateway.2wire.net> <20120415140628.GA4536@burratino>
In-Reply-To: <20120415140628.GA4536@burratino>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201204161905.13260.bugs@humanleg.org.uk>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2012, Jonathan Nieder wrote:
> Lars, Robert, anon: can you try 3.4-rc2 or newer and let us know how
> it goes?  I suspect v3.4-rc2~24^2~4 ("x86: Preserve lazy irq disable
> semantics in fixup_irqs()") will fix this.

Hmm, no, 3.4-rc2 seems to produce the same results I'm afraid.


robert.
