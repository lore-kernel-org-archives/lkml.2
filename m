Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1HWKYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:24:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52374 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1HWKYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:24:54 -0400
Date: Tue, 23 Aug 2011 11:21:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Claudio Scordino <claudio@evidence.eu.com>, Greg KH <greg@kroah.com>,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Bernhard Roth <br@pwrnet.de>
Subject: Re: [PATCH] atmel_serial: RS485: receiving enabled when sending
	data
Message-ID: <20110823102116.GF19622@n2100.arm.linux.org.uk>
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4E536536.3030004@evidence.eu.com> <20110823093035.GB19622@n2100.arm.linux.org.uk> <4E537BB3.60001@evidence.eu.com> <20110823111438.5d6b286d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823111438.5d6b286d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 11:14:38AM +0100, Alan Cox wrote:
> > atmel_serial: RS485: receiving enabled when sending data
> > 
> > By default the atmel_serial driver in RS485 mode disables receiving data until
> > all data in the send buffer has been sent. This flag allows to receive data
> > even whilst sending data.
> > 
> > Signed-off-by: Bernhard Roth <br@pwrnet.de> 
> > Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> (although when we have people having a serious meta discussion about four
>  spaces, or a tab or neither rather than functionality I despair)

We could ignore it, but then we end up with code being randomly
formatted throughout files, which makes it _more_ likely that the
code will be misread later.  That in turn makes the chances of
bugs introduced more likely in the future.

It also encourages 'cleanup' patches further down the line, so more
churn - which is something that Linus has been complaining about,
particularly in regard to ARM stuff.

It's far better to get things right the first time round than have
to keep touching stuff time and time again - either because of
cleanup patches or because of subtle bugs introduced by misreading
the code.
