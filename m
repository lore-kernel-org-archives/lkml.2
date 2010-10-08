Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0JHQb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:31:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48554 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427Ab0JHQb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:31:26 -0400
Date: Fri, 8 Oct 2010 17:56:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
Message-ID: <20101008175636.766dd1f5@lxorguk.ukuu.org.uk>
In-Reply-To: <1286551434.4153.21.camel@m0nster>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	<20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	<1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	<20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	<1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
	<1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com>
	<20101008091331.74871a42@lxorguk.ukuu.org.uk>
	<1286551434.4153.21.camel@m0nster>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm assuming Hyok added this because it wasn't easy or possible to
> change the file system .. I can imagine there are debugging situations
> where that's true.

Well stop assuming. You cc'd Hyok so let him speak for himself if he
cares about it and has an example.

> I don't think the kernel is going to implode if we allow an optional
> ttyS override for debugging purposes.. I just don't see that "screwing"
> up the kernel.

That is perhaps why you are not a subsystem maintainer.

Alan
