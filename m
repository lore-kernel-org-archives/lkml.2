Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1HAOiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:38:46 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:35922 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1HAOil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:38:41 -0400
Date: Mon, 1 Aug 2011 17:31:08 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux, binary blob and binary driver summary for vendors?
Message-ID: <20110801143108.GU29803@nalle>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <20110801134212.GS29803@nalle> <20110801151302.7d56cd0d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801151302.7d56cd0d@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 03:13:02PM +0100, Alan Cox wrote:
> On Mon, 1 Aug 2011 16:42:12 +0300
> Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> 
> > What is a good and also technically detailed summary of the binary blob and
> > driver issues with Linux kernel and GPL?
> > 
> > I'd like to refer a vendor to some documentation regarding this instead
> > writing a ton of text with IANAL everywhere.
> 
> I would suggest they talk to the Linux Foundation. It's basically a legal
> question around derivative works, and that's a lawyer question that tends
> to need looking at by lawyers per piece of code.

Good point, thanks.

> Aside from that there are technical, marketing and PR things to consider.

For the technical issues I've found Documentation/stable_api_nonsense.txt
and these links:

http://www.linuxfoundation.org/collaborate/workgroups/technical-advisory-board-tab/lfstatement
http://en.wikipedia.org/wiki/Binary_blob

These should be enough to start. Next question will hopefully be answered by
the staging tree.

-Mikko
