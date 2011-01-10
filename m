Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1AJNwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:52:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33612 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756Ab1AJNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:52:45 -0500
Date: Mon, 10 Jan 2011 13:49:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] char nvtty: Network Virtual Terminal support
Message-ID: <20110110134955.05d0d8a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110110133055.GM23771@enneenne.com>
References: <1294664819-17960-1-git-send-email-giometti@linux.it>
	<1294664819-17960-2-git-send-email-giometti@linux.it>
	<20110110131332.622e8a0d@lxorguk.ukuu.org.uk>
	<20110110133055.GM23771@enneenne.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I well understood the pty/tty pair modem lines they can be used to
> send receive serial data but they cannot be used to set the serial
> parameters since the slave doesn't send to the master the serial
> settings a userland application does on it, doesn't it?

Currently this is the case.

> > Otherwise its a very nice implementation of something I don't think we
> > should have implemented in the kernel.
> 
> Thanks, but I still don't understand how I can set the serial settings
> without a specific tty driver and just using the pty/tty pair modem
> lines... :'(

I'd rather see either tweaks to the pty/tty code to support this and
modem line setting, or something like your nvt which can be used for
arbitary protocols rather than being tied to the nvt telnet protocol
limits.

Alan
