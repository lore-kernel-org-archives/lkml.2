Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2DRKlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:41:49 -0400
Received: from 4607ds7-vby.0.fullrate.dk ([95.166.183.192]:60274 "EHLO
	cow.netcompartner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2DRKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:41:47 -0400
X-Greylist: delayed 2306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 06:41:47 EDT
From: Lars Boegild Thomsen <lth@cow.dk>
Organization: Call of the Wild BBS
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Date: Wed, 18 Apr 2012 18:03:00 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.7.4; x86_64; ; )
Cc: Robert Scott <bugs@humanleg.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>, mingo@redhat.com,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        JBeulich@novell.com, xen-devel@lists.xensource.com,
        e568b31a443d@6cc2cce7af2d.anonbox.net,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <201204161905.13260.bugs@humanleg.org.uk> <20120417020433.GA15848@burratino>
In-Reply-To: <20120417020433.GA15848@burratino>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204181803.00383.lth@cow.dk>
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "cow.netcompartner.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Tuesday 17 April 2012 10:04:33 Jonathan Nieder wrote: >
    > Hmm, no, 3.4-rc2 seems to produce the same results I'm afraid. > Alas.
   Does suspend-to-disk ("echo disk >/sys/power/state") have the > same problem?
    Can you get a log of the failure with > "no_console_suspend" appended to
   the kernel command line, for example > with a serial console or netconsole?
    [...] 
 Content analysis details:   (-2.9 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012 10:04:33 Jonathan Nieder wrote:
> > Hmm, no, 3.4-rc2 seems to produce the same results I'm afraid.
> Alas.  Does suspend-to-disk ("echo disk >/sys/power/state") have the
> same problem?  Can you get a log of the failure with
> "no_console_suspend" appended to the kernel command line, for example
> with a serial console or netconsole?

Using a serial console is a bit of a problem on this netbook as it hasn't got 
a serial port.  Not sure how the netconsole works - will read up on that.

And no - suspend to disk works fine.

I have by the way experimentally switched to 32bit version and it's the same 
thing (originally I was running 64bit version but that really doesn't make 
sense on a netbook - except doing it because it could be done).

//Lars...
