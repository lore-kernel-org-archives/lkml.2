Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2C0Vvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:51:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2C0Vvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:51:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] firmware_class: Reorganize fw_create_instance()
Date: Tue, 27 Mar 2012 23:56:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203260000.34377.rjw@sisk.pl> <201203272347.06621.rjw@sisk.pl> <20120327214941.GA21812@kroah.com>
In-Reply-To: <20120327214941.GA21812@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203272356.02771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 27, 2012, Greg KH wrote:
> On Tue, Mar 27, 2012 at 11:47:06PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, March 27, 2012, Stephen Boyd wrote:
> > > Recent patches to split up the three phases of request_firmware()
> > > lead to a casting away of const in fw_create_instance(). We can
> > > avoid this cast by splitting up fw_create_instance() a bit.
> > > 
> > > Make _request_firmware_setup() return a struct fw_priv and use
> > > that struct instead of passing struct firmware to
> > > _request_firmware(). Move the uevent and device file creation
> > > bits to the loading phase and rename the function to
> > > _request_firmware_load() to better reflect its purpose.
> > > 
> > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > 
> > Looks good to me.
> > 
> > Greg, if that's fine with you, I'll add this patch (and the next one)
> > to my firmware_class series you've looked at recently.
> 
> Yes, it's fine with me:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cool, thanks!

Rafael
