Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2GBFw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 01:52:27 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:44095 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2GBFwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 01:52:25 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au5PAPI28U9V5qg+PGdsb2JhbAA9CIoVrEUZAQEBAR4ZDSeCGAEBBTocIxAIAw4KLhQlChqIIrsfFIsnFgmFG2ADlTOFZox/gVY
X-IronPort-AV: E=Sophos;i="4.77,508,1336341600"; 
   d="scan'208";a="73121918"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 2 Jul 2012 07:52:31 +0200
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120702055231.GA3603@polaris.bitmath.org>
References: <20120628131651.GA14492@gherkin.frus.com>
 <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
 <20120629033600.GA3591@gherkin.frus.com>
 <20120630033519.GA4792@kroah.com>
 <20120701201411.GB8603@gherkin.frus.com>
 <20120701204118.GA1018@polaris.bitmath.org>
 <20120701232542.GA11680@gherkin.frus.com>
 <20120702002951.GA2184@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702002951.GA2184@gherkin.frus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 07:29:51PM -0500, Bob Tracy wrote:
> On Sun, Jul 01, 2012 at 06:25:42PM -0500, Bob Tracy wrote:
> > On Sun, Jul 01, 2012 at 10:41:18PM +0200, Henrik Rydberg wrote:
> > > If you did a 'make oldconfig' on anything prior to -rc5, chances are
> > > you do not have CONFIG_HID_GENERIC=y in your .config.
> > 
> > That might well be the missing "glue."  I'm building -rc5 as I type
> > this.  Should have an answer in a few hours.  Thanks for the clue!
> 
> That was it!  Thank you!  Keyboard and mouse now working fine.
> 
> Unless there was a way to get the CONFIG_HID_GENERIC functionality
> via some other mechanism prior to -rc5, I'd classify this as a
> regression introduced in 3.5-rc1 that was fixed in -rc5.

The option has been there since 3.5-rc1, but it was buried in the
special drivers section, with a help text saying nothing about its
significance. The Hitchhiker's Guide says it quite well, I think:

  "You hadn't exactly gone out of your way to call attention to them
  had you? I mean like actually telling anyone or anything."

  "But the plans were on display..."

  "On display? I eventually had to go down to the cellar to find
  them."

  "That's the display department."

  "With a torch."

  "Ah, well the lights had probably gone."

  "So had the stairs."

  "But look you found the notice didn't you?"

  "Yes", said Arthur, "yes I did. It was on display in the bottom of a
  locked filing cabinet stuck in a disused lavatory with a sign on the
  door saying Beware of The Leopard".

Henrik
