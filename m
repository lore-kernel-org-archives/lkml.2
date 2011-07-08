Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1GHQc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:32:56 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52829 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab1GHQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:32:54 -0400
X-Sasl-enc: QCrO020sNjhiAoNSxnuV3qNWQA/uXT4Y2PJked1qMDeS 1310142773
Date: Fri, 8 Jul 2011 09:32:19 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jcm@redhat.com, dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com,
        stefanr@s5r6.in-berlin.de, hare@suse.de
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Message-ID: <20110708163219.GB2646@kroah.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
 <20110708145408.GA2283@kroah.com>
 <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
 <20110708154736.GA7320@kroah.com>
 <1310140451.3282.85.camel@mulgrave>
 <20110708160403.GB31500@kroah.com>
 <1310141857.3282.87.camel@mulgrave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310141857.3282.87.camel@mulgrave>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 11:17:36AM -0500, James Bottomley wrote:
> On Fri, 2011-07-08 at 09:04 -0700, Greg KH wrote:
> > Do you seriously think that this sysfs attribute can be removed someday
> > in the future if we get structured logging implemented?  It can't,
> > sorry, people will start depending on this and their jury-rigged
> > implementations will require it no matter what we do otherwise.
> 
> Yes, it can.  The way we do that is to make udev the interface to this
> and the sysfs file becomes an internal udev implementation, not an
> external ABI.

No, sorry, you just described the "external" abi in the
Documentation/ABI directory.

> Any program using it rather than udev that breaks, well, tough, it
> used the wrong interface.

Again, no, we can't do that as you should well know.

And see Kay's response as to how udev will not be using this interface
by default anyway, so I don't see how you will ever be able to remove
this sysfs file once it is added.

greg k-h
